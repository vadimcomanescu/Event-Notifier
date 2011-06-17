class Event
	attr_accessor :severity, :timestamp, :message
	def initialize severity, timestamp, message
		@severity = severity
		@timestamp = timestamp
		@message = message
	end
end

class EventService
	attr_accessor :subscriptions

	def initialize
		@subscriptions = []
	end

	def add_subscription subscription
		@subscriptions << subscription unless @subscriptions.include? subscription
	end

	def unsubscribe subscription
		@subscriptions.delete(subscription)
	end

	def publish event
		@subscriptions.each {|subscription| subscription.last.notify event if event.class.name.eql?(subscription.first)}
	end
end

class EventSubscriber
	def notify event
	end

end
RSpec::Matchers.define :include_only_once do |expected|
	match do |actual|
		actual.count(expected) == 1
	end
end
describe "Event" do 
	it "should have a severity a timestamp and a message" do 
		event = Event.new("low", "1980-01-24 23:45", "message")
		event.severity.should == "low"
		event.timestamp.should == "1980-01-24 23:45"
		event.message.should == "message"
	end
end

describe "EventService" do
	before (:each) do
		@event_service = EventService.new
		@event = Event.new("fault", "1980-01-01 23:45", "messagge")
	end
	context "Adding and removing event subscriptions" do

		it "should be able to add a new subscription" do 
			subscription = ["fault", EventSubscriber.new] 
			@event_service.add_subscription(subscription)
			@event_service.subscriptions.should include(subscription)
		end

		it "should not add duplicate subscriptions" do 
			subscription = ["fault", EventSubscriber.new]
			@event_service.add_subscription(subscription)
			@event_service.add_subscription(subscription)
			@event_service.subscriptions.should include_only_once(subscription)
		end

		it "should be able to remove a subscription" do
			subscription = ["fault", EventSubscriber.new]
			@event_service.add_subscription(subscription)
			@event_service.unsubscribe(subscription)
			@event_service.subscriptions.should_not include(subscription)
		end
	end
	context "When publishing events" do
		it "should notify all subscribers that have a subscription for that event type when publishing an event" do
			subscriber = mock
			subscriber.should_receive(:notify).once.with(@event)
			subscription = ["Event", subscriber]
			@event_service.add_subscription subscription
			@event_service.publish @event	
		end
		
		it "should not notify subscribers that dont have a subscription for that event type when publishing an event" do
			subscriber = mock
			subscriber.should_not_receive(:notify)
			subscription = ["NotInterestingEvent", subscriber]
			@event_service.add_subscription subscription
			@event_service.publish @event
		end
	end
end
