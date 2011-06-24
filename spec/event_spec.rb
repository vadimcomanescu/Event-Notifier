$LOAD_PATH.unshift(File.dirname(__FILE__) )
require "event"

describe "Event" do 
	it "should have a severity a timestamp and a message" do 
		event = Event.new("low", "1980-01-24 23:45", "message")
		event.severity.should == "low"
		event.timestamp.should == "1980-01-24 23:45"
		event.message.should == "message"
	end

	it "should have a string representation as its containing messagge" do
		event = Event.new("low", "1980", "message")
		event.to_s.should == "message"
	end
end

