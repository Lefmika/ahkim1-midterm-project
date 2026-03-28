class ReservationEvent
  attr_reader :status, :location, :timestamp, :notes

  VALID_STATUSES = %w[
    confirmed checked_in checked_out
    do_not_disturb service_requested
  ]

  def initialize(status:, location:, timestamp:, notes: nil)
    raise ArgumentError, "Invalid status" unless VALID_STATUSES.include?(status)

    @status = status
    @location = location
    @timestamp = timestamp
    @notes = notes
  end

  def to_s
    "[#{@timestamp}] #{@status} at #{@location}"
  end
end