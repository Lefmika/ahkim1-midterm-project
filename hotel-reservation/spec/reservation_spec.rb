require 'rspec'
require_relative '../lib/reservation'
require_relative '../lib/rooms/standard_room'

# Test double (spy) for notifier
class TestNotifier
  attr_reader :notifications

  def initialize
    @notifications = []
  end

  def notify(reservation, event)
    @notifications << { reservation: reservation, event: event }
  end
end

RSpec.describe Reservation do
  let(:room) { StandardRoom.new(101, 2) }
  let(:notifier1) { TestNotifier.new }
  let(:notifier2) { TestNotifier.new }

  describe "#initialize" do
    it "creates a reservation with valid attributes" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      expect(reservation.guest_name).to eq("Alice")
      expect(reservation.confirmation_number).to start_with("RES")
    end

    it "raises error if no notifiers provided" do
      expect {
        Reservation.new(
          guest_name: "Alice",
          room: room,
          notifiers: []
        )
      }.to raise_error(ArgumentError, "At least one notifier is required")
    end
  end

  describe "#update_status" do
    it "adds a new event to history" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: "2025-06-15 14:00:00"
      )

      expect(reservation.history.length).to eq(1)
    end

    it "stores correct event data" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "checked_in",
        location: "Room 101",
        timestamp: "2025-06-15 15:00:00",
        notes: "Late arrival"
      )

      event = reservation.history.first

      expect(event.status).to eq("checked_in")
      expect(event.location).to eq("Room 101")
      expect(event.timestamp).to eq("2025-06-15 15:00:00")
      expect(event.notes).to eq("Late arrival")
    end

    it "notifies all notifiers" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1, notifier2]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: Time.now
      )

      expect(notifier1.notifications.length).to eq(1)
      expect(notifier2.notifications.length).to eq(1)
    end

    it "passes correct arguments to notifiers" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: Time.now
      )

      notification = notifier1.notifications.first

      expect(notification[:reservation]).to eq(reservation)
      expect(notification[:event].status).to eq("confirmed")
    end

    it "maintains chronological order of events" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: "t1"
      )

      reservation.update_status(
        status: "checked_in",
        location: "Room 101",
        timestamp: "t2"
      )

      expect(reservation.history.map(&:status)).to eq(["confirmed", "checked_in"])
    end
  end

  describe "#latest_status" do
    it "returns 'not_yet_confirmed' if no events exist" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      expect(reservation.latest_status).to eq("not_yet_confirmed")
    end

    it "returns the most recent status" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: Time.now
      )

      reservation.update_status(
        status: "checked_in",
        location: "Room 101",
        timestamp: Time.now
      )

      expect(reservation.latest_status).to eq("checked_in")
    end
  end

  describe "#history" do
    it "returns a copy of events (not the original array)" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      reservation.update_status(
        status: "confirmed",
        location: "Front Desk",
        timestamp: Time.now
      )

      history = reservation.history
      history << "fake_event"

      expect(reservation.history.length).to eq(1)
    end
  end

  describe "#total_cost" do
    it "delegates cost calculation to the room" do
      reservation = Reservation.new(
        guest_name: "Alice",
        room: room,
        notifiers: [notifier1]
      )

      expect(reservation.total_cost).to eq(room.cost)
    end
  end
end