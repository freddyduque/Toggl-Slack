#!/usr/bin/ruby

require_relative 'lib/togglV8'
require 'awesome_print'
require 'slack-notifier'
require 'time'
require 'thor'

class Tracker_cli < Thor
  attr_accessor :debug

  desc "tknzr", "TT=Toggle Token, SW=Slack WebHook URL, SU=Slack User Account, TL=Time to Analyze, BN=Default BOT Name, DB=[true] if you want to activate Debug Mode"

  option :sw, :required => true
  option :tt, :required => true
  option :tl, :required => true
  option :su
  option :db
  option :bn

  def tknzr()
    self.debug_on(options[:db]) if !options[:db].nil? && options[:db]=="true"

    ap "Slack WebHook URL: #{options[:sw]}" if @debug                                           # Printing Received Information
    ap "Toggl token: #{options[:tt]}" if @debug
    ap "Time to Analyze: #{options[:tl]}" if @debug
    ap "Slack User Account: #{options[:su]}" if @debug
    ap "Debug Mode: #{options[:db]}" if @debug
    ap "BOT Name: #{options[:bn]}" if @debug

    toggl_hash = connect_toggl(options[:tt])                                                    # Get the Toggl User Information
    ap toggl_hash if @debug

    tgl_task = get_running_task(toggl_hash)                                                     # Get Running Task
    ap tgl_task if @debug

    tgl_task.has_value?("error") ? (ap tgl_task):(proccess_task(tgl_task))                      # Check if the returned hash has the necessary information 
  end

  desc "proccess_running_task","Process the Running Task"                                       # Get the Running Time and Notification Type
  def proccess_task(tgl_task)
    tgl_task.merge!({"running_time" => get_running_time(tgl_task)})

    tgl_not_type = get_notification_type(options[:tl].to_i,tgl_task["running_time"])            # Get the Notification Type
    tgl_task.merge!(tgl_not_type)
    
    tgl_not_type.has_value?("error") ? (ap tgl_not_type):(proccess_notification_task(tgl_task)) # Check if the returned hash has the necessary information 
  end

  desc "proccess_notification_task","Process the Notification Task"
  def proccess_notification_task(tgl_task)
    def_conf = set_default_slack_conf(options[:su],options[:bn])                                # Set the Default Slack Configuration
    slack_con = connect_slack(options[:sw],def_conf)                                            # Set the Slack Connection

    main_message = get_main_message(tgl_task,def_conf)                                          # Set the Main Message
    attachment_message = set_attachment_hash(tgl_task)                                          # Set the Attachment Notification Theme Hash

    slack_con.ping main_message, attachments: attachment_message                                # Send the Message to Slack using 'slack-notifier'
  end

  desc "set_attachment_hash", "Fill it up"                                                      # Set the Notification pattern
  def set_attachment_hash(tgl_task)
    pretext = "Please! check the following on your Toggle Timer"
    text = "\*Task description:\* \_#{tgl_task.key?("description") ? "#{tgl_task["description"]}" : "No Description"}\_\n\*Running Time:\* #{tgl_task["running_time"]} seconds or #{Time.at(tgl_task["running_time"]).utc.strftime("%H:%M:%S")}\n\*Status:\* #{tgl_task["status"]}"
    color = tgl_task["color"]
    title = "Toggle Information"
    title_link = "https://www.toggl.com/app/timer"
    mrkdwn_in = ["text","pretext"]
    return [{pretext: pretext,text: text,color: color,title: title,title_link: title_link,mrkdwn_in: mrkdwn_in}]
  end

  desc "connect_toggl", "Fill it up"                                                            # Set the Connection with Toggl
  def connect_toggl(toggle_tok)
    t_con = Toggl.new(toggle_tok)
    return t_con.me(true)
  end

  desc "connect_slack", "Fill it up"                                                            # Set the Connection with Slack
  def connect_slack(slack_hook,opt_hash)
    return Slack::Notifier.new slack_hook, opt_hash
  end

  desc "get_main_message","Get the Main Message to show on Slack"                               # Get the Main Message to show on Slack
  def get_main_message(tgl_task,def_conf)
    return s_msg = "Hi #{tgl_task["fullname"]} #{def_conf[:channel] if def_conf[:channel].start_with? '@'} This is a friendly notification"        
  end

  desc "set_default_slack_conf", "Load Slack default Configuration"                             # Set the Default Slack Configuration
  def set_default_slack_conf(s_channel="#general",s_botname="BOT_HMD",s_link_names=1,s_icon_emoji=":space_invader:")
    s_channel="#general" if s_channel.nil
    s_botname="BOT_HMD" if s_botname.nil?
    return {channel: s_channel, username: s_botname, link_names: s_link_names, icon_emoji: s_icon_emoji}
  end

  desc "get_running_task", "Fill it up"                                                         # Get the Current Running Task in Toggl
  def get_running_task(t_info)
    if t_info.key?("time_entries")
      t_info["time_entries"].each do |i|
        return i.merge({"fullname" => t_info["fullname"]}) if i.key?("stop") == false
      end
      return {"type" => "error", "description" => "This User has no Running Tasks", "time" => "#{Time.new}"}
    else
      return {"type" => "error", "description" => "This User has no Tasks", "time" => "#{Time.new}"}
    end
  end

  desc "get_running_time", "Get Running Time"                                                   # Get the task's running time in secs
  def get_running_time(t_info)
    c_time_full = Time.now().localtime("+00:00")
    r_time_sec = c_time_full.to_i+t_info["duration"]
    ap "Running Time: #{r_time_sec} seconds or #{Time.at(r_time_sec).utc.strftime("%H:%M:%S")}" if @debug
    return r_time_sec.to_i
  end

  desc "get_notification_type", "Check if the task has been running for more than the expected" # Stablish the Running time thresholds
  def get_notification_type(threshold,current_runtime)
    th_hash = set_notification_threshold(threshold)
    ap th_hash if @debug
    case current_runtime
    when th_hash[0][:min] .. th_hash[0][:max]
        return {"status" => "Notification","color" => "#00CC00"}
    when th_hash[1][:min] .. th_hash[1][:max]
        return {"status" => "Warning","color" => "#FFFF00"}
    when th_hash[2][:min] .. th_hash[2][:max]
        return {"status" => "Danger","color" => "#FF8000"}
    when th_hash[3][:min] .. th_hash[3][:max]
        return {"status" => "Houston, We've got a Problem!","color" => "#FF0000"}
    else
        return {"type" => "error", "description" => "There is no Notification for this User and Task", "time" => "#{Time.new}"}
    end
  end

  desc "set_notification_threshold", "Set the Notification Threshold for each type of status"   # Recursive function to set the notifications threshold
  def set_notification_threshold(th,th_plus=th,i=0,th_hash=Hash.new,percent=th*0.25)
    th_hash[i] = {min: th_plus-percent,max: (th_plus+th)-percent}
    i == 3 ? (return th_hash) : (set_notification_threshold(th,th_plus*=2,i+=1,th_hash))
  end

  desc "debug_on", "Turn Debug Mode ON"                                                         # Enable and Disable Debug Mode
  def debug_on(debug=true)
    ap "Debugging is ON"
    @debug = debug
  end
end
Tracker_cli.start(ARGV)