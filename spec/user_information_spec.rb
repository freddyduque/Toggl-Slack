require 'user'

RSpec.describe User do
  describe "#Information" do
    context "with no parameters," do
      it "return the corresponding error and description" do
        user = User.new
        ap user.information
        expect(user.information).to eq(error: -1, description: "No Arguments")
      end
    end

    context "with a wrong Token and just one parameter" do
      it "return the corresponding error and description" do
        user = User.new "1971800d4d82861d8f2c1651fea4d212"
        expect(user.information).to eq(error: -1, description: "Wrong Token or User doesn't Exist")
      end
    end

    context "with a wrong Token and wrong Time Limit parameter" do
      it "return the corresponding error and description" do
        user = User.new "1971800d4d82861d8f2c1651fea4d212", "123ae"
        expect(user.information).to eq(error: -1, description: "Wrong Token or User doesn't Exist")
      end
    end

    context "with an existing Token" do
      it "return the custom User Information" do
        user = User.new "d396742070d0b5e3ae602c7baca8bb3d"
        expect(user.information).to have_key("id")
      end
    end

    context "with an existing Token and wrong Time Limit parameter" do
      it "return the corresponding error and description" do
        user = User.new "d396742070d0b5e3ae602c7baca8bb3d", "aed222"
        expect(user.information).to eq(error: -1, description: "Time Limit is not Numeric or Higher than 1 second")
      end
    end

    context "with an existing Token and wrong Time Limit parameter" do
      it "return the corresponding error and description" do
        user = User.new "d396742070d0b5e3ae602c7baca8bb3d", 1
        expect(user.information).to eq(error: -1, description: "Time Limit is not Numeric or Higher than 1 second")
      end
    end
=begin
    context "with a wrong Token" do
      it "return 'nil' if the user doesn't exit" do
        user = User.new "1971800d4d82861d8f2c1651fea4d212"
        expect(user.information).to eq(nil)
      end
    end
=end
  end
end