require 'slack-notifier'
require 'awesome_print'

class Supervisor
  attr_accessor :connection, :message

  # Initializes the User Class
  def initialize(webhook=nil)
    @message = @connection = Hash.new {|h,k| h[k]=[]}
    unless webhook.nil?
      if webhook == ""
        @connection["z_error"] << {code: -3, description: "WebHook is empty"}
      else
        @connection = Slack::Notifier.new webhook, {channel: "#general", username: "BOT", link_names: 1}
      end
    else
      @connection["z_error"] << {code: -3, description: "No Arguments"}
    end
  end

  # Sends the Message
  def send(message=nil)
    awe = @connection.ping message, attachments: [@message]
    case awe.body
    when "ok"
      @connection = {connection: "ok"}
    when "Bad token"
      @connection = {"z_error" => [{code: -3, description: "Bad token"}]}
    when ""
      @connection = {"z_error" => [{code: -3, description: "Wrong URL"}]}
    when "No token"
      @connection = {"z_error" => [{code: -3, description: "No token"}]}
    else
      return false                                     
    end
  end
end