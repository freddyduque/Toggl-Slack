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

  def toggl_slack
    self.debug_on(options[:db]) if !options[:db].nil? && options[:db]=="true"

    # Printing Received Information
    ap options if @debug

    user = User.new options[:tt],options[:tl]
    ap user.information if @debug

    if user.notify
      supervisor = Supervisor.new options[:sw]

      supervisor.connection.channel=options[:su]
      options[:bn].nil? ? (supervisor.connection.username="BOT_HMD"):(supervisor.connection.username=options[:bn])

      supervisor.message["pretext"]="Please! check the following on your Toggle Timer"
      supervisor.message["text"]="\*Task description:\* \_#{user.time_entry.key?("description") ? "#{user.time_entry["description"]}" : "No Description"}\_\n\*Running Time:\* #{user.time_entry["z_running_time"]} seconds or #{Time.at(user.time_entry["z_running_time"]).utc.strftime("%H:%M:%S")}\n\*Status:\* #{user.notify["z_type"]}"
      supervisor.message["color"]=user.notify["z_color"]
      supervisor.message["title"]="Toggle Information"
      supervisor.message["title_link"]="https://www.toggl.com/app/timer"
      supervisor.message["mrkdwn_in"]=["text","pretext"]
      supervisor.send("Hi #{user.information["fullname"]} #{supervisor.connection.channel if supervisor.connection.channel.start_with? '@'} This is a friendly notification")
    end
  end
  
  # Enable and Disable Debug Mode
  desc "debug_on", "Turn Debug Mode ON"
  def debug_on(debug=true)
    ap "Debug mode is ON"
    @debug = debug
  end
end
Toggl_Slack.start(ARGV)