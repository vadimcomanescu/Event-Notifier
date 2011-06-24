class Event
	attr_accessor :severity, :timestamp, :message
	def initialize severity, timestamp, message
		@severity = severity
		@timestamp = timestamp
		@message = message
	end

	def to_s
		@message
	end
end

