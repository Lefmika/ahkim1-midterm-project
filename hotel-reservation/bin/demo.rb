#!/usr/bin/env ruby

require_relative '../lib/rooms/standard_room'
require_relative '../lib/rooms/suite_room'
require_relative '../lib/rooms/cabana_room'
require_relative '../lib/reservation'
require_relative '../lib/notifiers/text_notifier'
require_relative '../lib/notifiers/email_notifier'
require_relative '../lib/notifiers/front_desk_notifier'

puts "=== Hotel Reservation Management System Demo ==="
puts

# Create Room
puts "Creating room..."
room = SuiteRoom.new(204, 3)
puts room
puts

# Show cost
puts "Estimated stay cost: $#{'%.2f' % room.cost}"
puts

# Create Notifiers
puts "Creating reservation with all notifiers..."
text_notifier = TextNotifier.new("555-0192")
email_notifier = EmailNotifier.new("carol@example.com")
front_desk_notifier = FrontDeskNotifier.new

reservation = Reservation.new(
  guest_name: "Carol",
  room: room,
  notifiers: [text_notifier, email_notifier, front_desk_notifier]
)

puts "Reservation created: #{reservation.confirmation_number} (Guest: #{reservation.guest_name})"
puts

puts "Tracking guest journey..."
puts

# --- CONFIRMED ---
puts "--- confirmed ---"
reservation.update_status(
  status: "confirmed",
  location: "Front Desk",
  timestamp: "2025-06-15 14:00:00"
)
puts

# --- CHECKED IN ---
puts "--- checked_in ---"
reservation.update_status(
  status: "checked_in",
  location: "Room 204",
  timestamp: "2025-06-15 15:30:00"
)
puts

# Summary Info
puts "Current status: #{reservation.latest_status}"
puts "Total events: #{reservation.history.length}"
puts

puts "Demo complete!"