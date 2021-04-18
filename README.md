# OmniAuth::OpenEdx

This is the OmniAuth stragegy for authenticaing to Open edX.

Note, this strategy only works with Open edX `juniper` release or above.

## Installation

Add to your `Gemfile`:

```ruby
gem "omniauth-open-edx"
```

## Open edX OAuth2 Toolkit Setup

- Go to `${LMS_URL}/admin/oauth2_provider/application`
- Add a new application
- Enter redirect url, this depends on your setup, learn more from [examples](./examples)
- Select `Confidential` client type, `Authorization code` authorization grant type
- Get the `Client id` and `Client secret` and configure them in your ruby application

## Usage

```ruby
use OmniAuth::Builder do
  provider :open_edx,
           ENV["OPEN_EDX_OAUTH_CLIENT_ID"],
           ENV["OPEN_EDX_OAUTH_CLIENT_SECRET"],
           {
             scope: "profile email",
             client_options: {
               site: "https://courses.edx.org",
             },
           }
end
```

## License

[MIT License](./LICENSE).
