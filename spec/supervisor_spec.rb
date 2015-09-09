#!/usr/bin/ruby

require 'supervisor'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "Supervisor message" do
  context "When there is NO parameters" do
    it "returns a NO argument error" do
      expect(supervisor_with_no_arguments).to have_key("z_error")
    end
  end

  context "When the webhook is wrong" do
    it "returns a webhook error" do
      expect(supervisor_with_webhook "").to have_key("z_error")               # code: -3, description: "WebHook is empty"      
      expect(supervisor_with_bad_url).to have_key("z_error")                  # code: -3, description: "Wrong URL"
      expect(supervisor_with_bad_token).to have_key("z_error")                # code: -3, description: "Bad token"
      expect(supervisor_with_no_token).to have_key("z_error")                 # code: -3, description: "No token"
    end
  end

  context "When the webhook is right" do
    it "returns ok, and message is sent" do
      expect(supervisor_with_good_token).to have_key(:connection)
    end
  end
end