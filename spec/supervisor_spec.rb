require 'supervisor'

RSpec.describe Supervisor do
  describe "#Message" do
    #1
    context "with no parameters," do
      it "return the corresponding error code and description, test 1" do
        supervisor = Supervisor.new
        expect(supervisor.connection["z_error"]).to eq([code: -3, description: "No Arguments"])
      end
    end
    #2
    context "with an empty webhook," do
      it "return the corresponding error code and description, test 2" do
        supervisor = Supervisor.new ""
        expect(supervisor.connection["z_error"]).to eq([code: -3, description: "WebHook is empty"])
      end
    end
    #3
    context "with a wrong URL format," do
      it "raise the corresponding error message, test 3" do
        supervisor = Supervisor.new "httpasddasdT/S2GDb2asdasdABSDOsss"        
        expect {supervisor.send("testing message")}.to raise_error(NoMethodError)
      end
    end
    #4
    context "with a wrong webhook," do
      it "return the corresponding error code and description, test 4" do
        supervisor = Supervisor.new "https://hooks.slack.com/services"    
        supervisor.send("testing message")
        expect(supervisor.connection["z_error"]).to eq([code: -3, description: "Bad token"])
      end
    end
    #5
    context "with a correct webhook," do
      it "return the corresponding error code and description, test 5" do
        supervisor = Supervisor.new "https://hooks.slack.com/services/T0887E294/B08K2UK0T/XXXXXXXXXXXXXXXXX"
        supervisor.send("testing message")
        expect(supervisor.connection).to eq("ok")
      end
    end
  end
end