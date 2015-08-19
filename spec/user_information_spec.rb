require 'user'

RSpec.describe User do
  describe "#Information" do
    context "with a wrong Token" do
      it "return 'nil' if the user doesn't exit" do
        user = User.new "1971800d4d82861d8f2c1651fea4d212"
        expect(user.information).to eq(nil)
      end
    end
    context "with an existing Token" do
      it "return the custom User Information" do
        user = User.new "b7342e19560109d976523b1f63c9a754"
        expect(user.information).to have_key("id")
      end
    end
  end
end