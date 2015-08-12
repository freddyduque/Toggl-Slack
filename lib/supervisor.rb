require 'slack-notifier'

class Supervisor
	# Initializes the User Class
	def initialize(webhook,s_channel="#general",s_botname="BOT_HMD",s_link_names=1,s_icon_emoji=":space_invader:")
		s_channel="#general" if s_channel.nil?
		s_botname="BOT_HMD" if s_botname.nil?
		@connection = Slack::Notifier.new webhook, {channel: s_channel, username: s_botname, link_names: s_link_names, icon_emoji: s_icon_emoji}
		@attachments = Hash.new
		@main_message = ""
	end

	# Gets the Channel
	def get_channel
		@connection.channel
	end

	# Gets the Bot Name
	def get_username
		@connection.username
	end

	# Sets the Main and Single Message
	def set_main_message(main_message)
		@main_message=main_message
	end

	# Gets the Main and Single Message
	def get_main_message()
		@main_message
	end

	# Sends the Message
	def send_message()
		@connection.ping @main_message, attachments: [@attachments]
	end

	# Sets the Attachment's Pretext
	def set_pretext(value)
		@attachments["pretext"]=value
	end

	# Sets the Attachment's Text
	def set_text(value)
		@attachments["text"]=value
	end

	# Sets the Attachment's Color
	def set_color(value)
		@attachments["color"]=value
	end

	# Sets the Attachment's Title
	def set_title(value)
		@attachments["title"]=value
	end

	# Sets the Attachment's Link
	def set_title_link(value)
		@attachments["title_link"]=value
	end

	# Gives Format to the Attachment
	def set_mrkdwn_in(value)
		@attachments["mrkdwn_in"]=value
	end
end