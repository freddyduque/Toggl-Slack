require 'slack-notifier'

class Supervisor
  attr_accessor :connection, :message
    
  # Initializes the User Class
  def initialize(webhook)
    @connection = Slack::Notifier.new webhook, {"channel" => "#general","username"=>"BOT","link_names"=>1}
    @message = Hash.new
  end

  # Sends the Message
  def send(message)
    @connection.ping message, attachments: [@message]#
  end
end