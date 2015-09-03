require 'user'

RSpec.describe User do
  describe ".information" do
    let(:token){{right: "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", wrong: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"}}

    context "When parameters are Right" do
      it "creates an user" do
        expect((User.new token[:right]).information).to have_key("id")
        expect((User.new token[:right],"10").information).to have_key("id")
        expect((User.new token[:right],"1.6").information).to have_key("id")
        expect((User.new token[:right], 60).information).to have_key("id")
        expect((User.new token[:right], 10.5).information).to have_key("id")
      end
    end

    context "When there is NO parameters" do
      it "returns a NO argument error" do
        expect((User.new).information).to have_key("z_error")                         # code: -2, description: "No Arguments"
      end
    end

    context "When parameters are Wrong" do
      it "returns a Parameters error" do
        expect((User.new token[:wrong]).information).to have_key("z_error")           # code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong],"10").information).to have_key("z_error")      # code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong],"1.6").information).to have_key("z_error")     # code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong], 60).information).to have_key("z_error")       # code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong], 10.5).information).to have_key("z_error")     # code: -2, description: "User doesn't exist"

        expect((User.new token[:wrong], "").information).to have_key("z_error")       # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong], "32s2").information).to have_key("z_error")   # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User doesn't exist"

        expect((User.new token[:wrong], "-3").information).to have_key("z_error")     # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User doesn't exist"
        expect((User.new token[:wrong], -3).information).to have_key("z_error")       # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User doesn't exist"

        expect((User.new "").information).to have_key("z_error")                      # code: -2, description: "User Token is empty"
        expect((User.new "","10").information).to have_key("z_error")                 # code: -2, description: "User Token is empty"
        expect((User.new "","1.6").information).to have_key("z_error")                # code: -2, description: "User Token is empty"
        expect((User.new "", 60).information).to have_key("z_error")                  # code: -2, description: "User Token is empty"
        expect((User.new "", 10.5).information).to have_key("z_error")                # code: -2, description: "User Token is empty"
        expect((User.new "","").information).to have_key("z_error")                   # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User Token is empty"
        expect((User.new "","32s2").information).to have_key("z_error")               # code: -1, description: "Time Limit is not Integer";  code: -2, description: "User Token is empty"
        expect((User.new "","-3").information).to have_key("z_error")                 # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User Token is empty"
        expect((User.new "",-3).information).to have_key("z_error")                   # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User Token is empty"
        expect((User.new "","10").information).to have_key("z_error")                 # code: -1, description: "Time Limit is lower than 1 second";  code: -2, description: "User Token is empty"

        expect((User.new token[:right], "").information).to have_key("z_error")       # code: -1, description: "Time Limit is not Integer"
        expect((User.new token[:right], "32s2").information).to have_key("z_error")   # code: -1, description: "Time Limit is not Integer"
        expect((User.new token[:right], "-3").information).to have_key("z_error")     # code: -1, description: "Time Limit is lower than 1 second"
        expect((User.new token[:right], -3).information).to have_key("z_error")       # code: -1, description: "Time Limit is lower than 1 second"
      end
    end
  end
end