#!/usr/bin/ruby

require_relative 'lib/user'
require_relative 'lib/supervisor'
require 'awesome_print'
require 'time'
require 'thor'

class Toggl_Slack < Thor
	attr_accessor :debug

	desc "toggle_slack", "TT=Toggle Token, SW=Slack WebHook URL, SU=Slack User Account, TL=Time to Analyze, BN=Default BOT Name, DB=[true] if you want to activate Debug Mode"

	option :sw, :required => true
	option :tt, :required => true
	option :tl, :required => true
	option :su
	option :db
	option :bn

	def toggle_slack
		self.debug_on(options[:db]) if !options[:db].nil? && options[:db]=="true"

		ap "Slack WebHook URL: #{options[:sw]}" if @debug                                           # Printing Received Information
		ap "Toggl token: #{options[:tt]}" if @debug
		ap "Time to Analyze: #{options[:tl]}" if @debug
		ap "Slack User Account: #{options[:su]}" if @debug
		ap "Debug Mode: #{options[:db]}" if @debug
		ap "BOT Name: #{options[:bn]}" if @debug

		user = create_user()
		task = user.get_running_task(options[:tl].to_i)
		ap task if @debug
		unless task.has_key?("z_type")
			supervisor = create_supervisor()
			supervisor.set_main_message("Hi #{user.get_user_fullname} #{supervisor.get_channel if supervisor.get_channel.start_with? '@'} This is a friendly notification")
			supervisor.set_pretext("Please! check the following on your Toggle Timer")
			supervisor.set_text("\*Task description:\* \_#{task.key?("description") ? "#{task["description"]}" : "No Description"}\_\n\*Running Time:\* #{task["z_running_time"]} seconds or #{Time.at(task["z_running_time"]).utc.strftime("%H:%M:%S")}\n\*Status:\* #{task["z_status"]}")
			supervisor.set_color(task["z_color"])
			supervisor.set_title("Toggle Information")
			supervisor.set_title_link("https://www.toggl.com/app/timer")
			supervisor.set_mrkdwn_in(["text","pretext"])
			supervisor.send_message()
		end
	end

	desc "create_user", "Create User"												# Create the User
	def create_user()
		User.new options[:tt]
	end

	desc "create_supervisor", "Create Supervisor"									# Create the Supervisor
	def create_supervisor()
		Supervisor.new options[:sw],options[:su],options[:bn]
	end

	desc "debug_on", "Turn Debug Mode ON"											# Enable and Disable Debug Mode
	def debug_on(debug=true)
		ap "Debugging is ON"
		@debug = debug
	end
end
Toggl_Slack.start(ARGV)