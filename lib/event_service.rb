
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
