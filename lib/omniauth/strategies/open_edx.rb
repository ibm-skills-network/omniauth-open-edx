# frozen_string_literal: true

# Learn more about the Open edX JWT Oauth2 flow
# https://github.com/edx/edx-platform/blob/master/openedx/core/djangoapps/oauth_dispatch/docs/decisions/0003-use-jwt-as-oauth-tokens-remove-openid-connect.rst

require "omniauth-oauth2"
require "jwt"

module OmniAuth
  module Strategies
    class OpenEdx < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "profile email"

      option :name, "open_edx"
      option :client_options,
             site: "https://courses.edx.org",
             authorize_url: "/oauth2/authorize",
             token_url: "/oauth2/access_token"
      option :scope, DEFAULT_SCOPE
      option :authorize_options, [:scope]

      option :token_options, [:token_type]
      option :token_params, token_type: "jwt"

      uid { raw_info["sub"] }

      info do
        {
          name: raw_info["name"],
          email: raw_info["email"],
          username: raw_info["preferred_username"],
          first_name: raw_info["given_name"],
          last_name: raw_info["family_name"]
        }
      end

      extra { { raw_info: raw_info } }

      def raw_info
        @raw_info ||= jwt_payload
      end

      def callback_url
        # overwrite this function from omniauth
        # https://github.com/omniauth/omniauth/blob/c2380ae848ce4e0e39b4bb94c5b8e3fd0a544825/lib/omniauth/strategy.rb#L444
        # edx greatly dislikes when query_string is part of the callback_url
        full_host + callback_path
      end

      def authorize_params
        super.tap do |params|
          %w[scope].each do |v|
            params[v.to_sym] = request.params[v] if request.params[v]
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private

      def jwt_payload
        JWT.decode(access_token.token, nil, false)[0]
      end
    end
  end
end
