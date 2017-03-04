require 'test_helper'

class EverythingOkayAlarm < TestClass
  def test_alarm
    assert true
  end

 	describe "#create_full_address" do
   	it "takes collection of clinic info and returns array of complete clinic addresses" do
        @clinic_addresses.class.should eq Array
    end
	end


end


