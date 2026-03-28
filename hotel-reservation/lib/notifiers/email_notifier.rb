class EmailNotifier
  def initialize(email)
    @guest_email = email
  end

  def notify(reservation, event)
    subject, opening = content_for(event.status)

    puts "[Email to #{@guest_email}]:"
    puts "Subject: #{subject.gsub("[confirmation_number]", reservation.confirmation_number)}"
    puts
    puts opening
    puts
    puts "Status   : #{event.status}"
    puts "Location : #{event.location}"
    puts "Time     : #{event.timestamp}"
    puts "Notes    : #{event.notes}" if event.notes
    puts "---"
  end

  private

  def content_for(status)
    {
      "confirmed" => [
        "Reservation Confirmed — [confirmation_number]",
        "We're pleased to confirm your upcoming reservation."
      ],
      "checked_in" => [
        "Welcome to Grand Hotel!",
        "Your room is ready. We hope you enjoy every moment of your stay."
      ],
      "checked_out" => [
        "Thank you for staying with us",
        "We hope you had a wonderful stay. Your visit means a lot to us."
      ],
      "do_not_disturb" => [
        "Do Not Disturb Activated",
        "Your Do Not Disturb preference has been recorded."
      ],
      "service_requested" => [
        "Service Request Received",
        "Thank you for reaching out. Our team will be with you shortly."
      ]
    }[status]
  end
end