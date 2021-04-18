begin
  require "sinatra"
  require "securerandom"
  require "omniauth"
  require "omniauth-open-edx"
rescue LoadError
  require "rubygems"
  require "securerandom"
  require "sinatra"
  require "omniauth"
  require "omniauth-open-edx"
end

set sessions: true
set :session_secret, ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :open_edx,
           ENV["OPEN_EDX_OAUTH_CLIENT_ID"],
           ENV["OPEN_EDX_OAUTH_CLIENT_SECRET"],
           {
             scope: "profile email",
             client_options: {
               site: "https://courses.edx.org"
             }
           }
end

get "/" do
  <<-HTML
  <form method='post' action='/auth/open_edx'>
    <input type="hidden" name="authenticity_token" value='#{request.env["rack.session"]["csrf"]}'>
    <button type='submit'>Sign in with Open edX</button>
  </form>
  HTML
end

get "/auth/:name/callback" do
  auth = request.env["omniauth.auth"]
  <<-HTML
  <h1>You are logged in as #{auth["info"]["email"]}</h1>
  <div>OmniAuth::AuthHash::InfoHash</div>
  <span>#{auth["info"].to_json}</span>
  HTML
end
