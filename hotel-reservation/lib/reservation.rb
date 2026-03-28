require_relative 'reservation_event'

class Reservation
  attr_reader :guest_name, :confirmation_number

  def initialize(guest_name:, room:, notifiers:)
    raise ArgumentError, "At least one notifier is required" if notifiers.empty?

    @guest_name = guest_name
    @room = room
    @notifiers = notifiers
    @events = []
    @confirmation_number = generate_confirmation
  end

  def update_status(status:, location:, timestamp:, notes: nil)
    event = ReservationEvent.new(
      status: status,
      location: location,
      timestamp: timestamp,
      notes: notes
    )

    @events << event

    @notifiers.each do |notifier|
      notifier.notify(self, event)
    end
  end

  def latest_status
    return "not_yet_confirmed" if @events.empty?
    @events.last.status
  end

  def history
    @events.dup
  end

  def total_cost
    @room.cost
  end

  private

  def generate_confirmation
    "RES#{Time.now.to_i}#{rand(100..999)}"
  end
end