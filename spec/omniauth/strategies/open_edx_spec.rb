require "spec_helper"

RSpec.describe OmniAuth::Strategies::OpenEdx do
  let(:jwt_token) do
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJTRVQtTUUtUExFQVNFIiwiZXhwIjoxNjE4ODA0NDkyLCJpYXQiOjE2MTg3Njg0OTIsImlzcyI6Imh0dHA6Ly9jb3Vyc2VzLmV4YW1wbGUuY29tL29hdXRoMiIsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIiwic2NvcGVzIjpbInByb2ZpbGUiLCJlbWFpbCJdLCJ2ZXJzaW9uIjoiMS4yLjAiLCJzdWIiOiIxMmI3Mzk1MGUwZTRhMzluZmQwOTY0NzFhMmVjYSIsImZpbHRlcnMiOlsidXNlcjptZSJdLCJpc19yZXN0cmljdGVkIjpmYWxzZSwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJBZG1pbiIsImZhbWlseV9uYW1lIjoiIiwiZ2l2ZW5fbmFtZSI6IiIsImFkbWluaXN0cmF0b3IiOnRydWUsInN1cGVydXNlciI6dHJ1ZSwiZW1haWwiOiJhZG1pbkBleGFtcGxlLmNvbSJ9.bsCLLaIWhO0YFW-ODA9nN9nycltoPHUKLa4UPjZV2js"
  end
  let(:access_token) { double("AccessToken", token: jwt_token) }

  let(:self_host_site) { "https://courses.example.com" }
  let(:self_host) do
    OmniAuth::Strategies::OpenEdx.new(
      "CLIENT_ID",
      "CLIENT_SECRET",
      { client_options: { site: self_host_site } }
    )
  end

  subject { OmniAuth::Strategies::OpenEdx.new({}) }

  before { allow(subject).to receive(:access_token).and_return(access_token) }

  context "client options" do
    it "should have correct site" do
      expect(subject.options.client_options.site).to eq(
        "https://courses.edx.org"
      )
    end

    it "should have correct authorization url path" do
      expect(subject.options.client_options.authorize_url).to eq(
        "/oauth2/authorize"
      )
    end

    it "should have correct token url path" do
      expect(subject.options.client_options.token_url).to eq(
        "/oauth2/access_token"
      )
    end

    describe "should be overridable" do
      it "for site" do
        expect(self_host.options.client_options.site).to eq(self_host_site)
      end
    end
  end

  context "info" do
    it "should have correct user info" do
      expect(subject.info[:name]).to eq("Admin")
      expect(subject.info[:username]).to eq("admin")
      expect(subject.info[:email]).to eq("admin@example.com")
    end
  end
end
