require 'user'

RSpec.describe User do
  describe "#Information" do
    #1
    context "with no parameters," do
      it "return the corresponding error code and description, test 1" do
        user = User.new
        expect(user.information["z_error"]).to eq([code: -2, description: "No Arguments"])
      end
    end
    # 2
    context "with an empty Token and no time limit parameter" do
      it "return the corresponding error code and description, test 2" do
        user = User.new ""
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User Token is empty"])
      end
    end
    # 3
    context "with an empty Token and empty time limit" do
      it "return the corresponding error code and description, test 3" do
        user = User.new "",""
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is not Integer"}, {:code=>-2, :description=>"User Token is empty"}])
      end
    end
    # 4
    context "with an empty Token and wrong Time Limit" do
      it "return the corresponding error code and description, test 4" do
        user = User.new "","32s2"
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is not Integer"}, {:code=>-2, :description=>"User Token is empty"}])
      end
    end
    # 5
    context "with an empty Token and lower than 1 second Time Limit as string" do
      it "return the corresponding error code and description, test 5" do
        user = User.new "","-3"
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is lower than 1 second"}, {:code=>-2, :description=>"User Token is empty"}])
      end
    end
    # 6
    context "with an empty Token and Time Limit (integer) as string" do
      it "return the corresponding error code and description, test 6" do
        user = User.new "","10"
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User Token is empty"])
      end
    end
    # 7
    context "with an empty Token and Time Limit (float) as string" do
      it "return the corresponding error code and description, test 7" do
        user = User.new "","1.6"
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User Token is empty"])
      end
    end
    # 8
    context "with an empty Token and lower than 1 second Time Limit" do
      it "return the corresponding error code and description, test 8" do
        user = User.new "",-3
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is lower than 1 second"}, {:code=>-2, :description=>"User Token is empty"}])
      end
    end
    # 9
    context "with an empty Token and Time Limit parameter as integer" do
      it "return the corresponding error code and description, test 9" do
        user = User.new "", 60
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User Token is empty"])
      end
    end
    # 10
    context "with an empty Token and Time Limit parameter as float" do
      it "return the corresponding error code and description, test 10" do
        user = User.new "", 10.5
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User Token is empty"])
      end
    end
    # 11
    context "with a wrong Token and just one parameter" do
      it "return the corresponding error code and description, test 11" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
        expect(user.information["z_error"]).to eq([code: -2, description: "User doesn't exist"])
      end
    end
    # 12
    context "with a wrong Token and empty Time Limit" do
      it "return the corresponding error code and description, test 12" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",""
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is not Integer"}, {:code=>-2, :description=>"User doesn't exist"}])
      end
    end
    # 13
    context "with a wrong Token and wrong Time Limit" do
      it "return the corresponding error code and description, test 13" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ","32s2"
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is not Integer"}, {:code=>-2, :description=>"User doesn't exist"}])
      end
    end
    # 14
    context "with a wrong Token and lower than 1 second Time Limit as string" do
      it "return the corresponding error code and description, test 14" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ","-3"
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is lower than 1 second"}, {:code=>-2, :description=>"User doesn't exist"}])
      end
    end
    # 15
    context "with a wrong Token and Time Limit (integer) as string" do
      it "return the corresponding error code and description, test 15" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ","10"
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User doesn't exist"])
      end
    end
    # 16
    context "with a wrong Token and Time Limit (float) as string" do
      it "return the corresponding error code and description, test 16" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ","1.6"
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User doesn't exist"])
      end
    end
    # 17
    context "with a wrong Token and lower than 1 second Time Limit" do
      it "return the corresponding error code and description, test 17" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",-3
        expect(user.information["z_error"]).to eq([{:code=>-1, :description=>"Time Limit is lower than 1 second"}, {:code=>-2, :description=>"User doesn't exist"}])
      end
    end
    # 18
    context "with a wrong Token and Time Limit parameter as integer" do
      it "return the corresponding error code and description, test 18" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", 60
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User doesn't exist"])
      end
    end
    # 19
    context "with a wrong Token and Time Limit parameter as float" do
      it "return the corresponding error code and description, test 19" do
        user = User.new "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ", 10.5
        expect(user.information["z_error"]).to eq([:code=>-2, :description=>"User doesn't exist"])
      end
    end
    # 20
    context "with an existing User and just one parameter" do
      it "return the custom User Information, test 20" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        expect(user.information).to have_key("id")
      end
    end
    # 21
    context "with an existing User and empty Time Limit" do
      it "return the corresponding error code and description, test 21" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",""
        expect(user.information["z_error"]).to eq([:code=>-1, :description=>"Time Limit is not Integer"])
      end
    end
    # 22
    context "with an existing User and wrong Time Limit" do
      it "return the corresponding error code and description, test 22" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","32s2"
        expect(user.information["z_error"]).to eq([:code=>-1, :description=>"Time Limit is not Integer"])
      end
    end
    # 23
    context "with an existing User and lower than 1 second Time Limit as string" do
      it "return the corresponding error code and description, test 23" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","-3"
        expect(user.information["z_error"]).to eq([:code=>-1, :description=>"Time Limit is lower than 1 second"])
      end
    end
    # 24
    context "with an existing User and Time Limit (integer) as string" do
      it "return the custom User Information, test 24" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","10"
        expect(user.information).to have_key("id")
      end
    end
    # 25
    context "with an existing User and Time Limit (float) as string" do
      it "return the custom User Information, test 25" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","1.6"
        expect(user.information).to have_key("id")
      end
    end
    # 26
    context "with an existing User and lower than 1 second Time Limit" do
      it "return the corresponding error code and description, test 26" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",-3
        expect(user.information["z_error"]).to eq([:code=>-1, :description=>"Time Limit is lower than 1 second"])
      end
    end
    # 27
    context "with an existing User and Time Limit parameter as integer" do
      it "return the custom User Information, test 27" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 60
        expect(user.information).to have_key("id")
      end
    end
    # 28
    context "with an existing User and Time Limit parameter as float" do
      it "return the custom User Information, test 28" do
        user = User.new "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", 10.5
        expect(user.information).to have_key("id")
      end
    end
  end
end