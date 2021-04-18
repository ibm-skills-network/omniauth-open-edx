begin
  require "sinatra"
  require "omniauth"
  require "omniauth-open-edx"
rescue LoadError
  require "rubygems"
  require "sinatra"
  require "omniauth"
  require "omniauth-open-edx"
end

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
  <a href='/auth/open_edx'>Sign in with Open edX</a>
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
