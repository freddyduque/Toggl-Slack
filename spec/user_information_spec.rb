#!/usr/bin/ruby

require 'user'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "User information" do  
  context "When parameters are Right" do
    it "creates an user" do
      expect(right_user_with_no_time).to have_key("id")
      expect(right_user_with_time "10").to have_key("id")
      expect(right_user_with_time "1.6").to have_key("id")
      expect(right_user_with_time 60).to have_key("id")
      expect(right_user_with_time 10.5).to have_key("id")
    end
  end

  context "When there is NO parameters" do
    it "returns a NO argument error" do
      expect(user_with_no_arguments).to have_key("z_error")                # code: -2, description: "No Arguments"
    end
  end

  context "When parameters are Wrong" do
    it "returns a Parameters error" do
      expect(wrong_user_with_no_time).to have_key("z_error")              # code: -2, description: "User doesn't exist"
      expect(wrong_user_with_time "").to have_key("z_error")              # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User doesn't exist"
      expect(wrong_user_with_time "32s2").to have_key("z_error")          # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User doesn't exist"
      expect(wrong_user_with_time -3).to have_key("z_error")              # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User doesn't exist"

      expect(right_user_with_time "").to have_key("z_error")              # code: -1, description: "Time Limit is not Integer"
      expect(right_user_with_time "32s2").to have_key("z_error")          # code: -1, description: "Time Limit is not Integer"
      expect(right_user_with_time -3).to have_key("z_error")              # code: -1, description: "Time Limit is lower than 1 second"
    end
  end
end