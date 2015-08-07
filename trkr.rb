#!/usr/bin/ruby

require_relative 'app/togglV8'
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

    ap "Slack WebHook URL: #{options[:sw]}" if @debug                               # Printing Received Information
    ap "Toggl token: #{options[:tt]}" if @debug  
    ap "Time to Analyze: #{options[:tl]}" if @debug   
    ap "Slack User Account: #{options[:su]}" if @debug      
    ap "Debug Mode: #{options[:db]}" if @debug 
    ap "BOT Name: #{options[:bn]}" if @debug 

=begin    
    slack_web=options[:sw]
    toggl_tok=options[:tt]
    time_limi=options[:tl]
    slack_use=options[:su]
    debug_mod=options[:db]
    def_bot_n=options[:bn]
=end

    tgl_hash = connect_t(options[:tt])                                              # Get the Toggl User Information
    ap tgl_hash if @debug

    tgl_task = get_running_task(tgl_hash)                                           # Get Running Task
    ap tgl_task if @debug                                                           

    if tgl_task.class == Hash                                                       # Check if the returned is a hash with the requested information or not
      running_time = get_running_time(tgl_task)                                     # Get the Running Time
      tgl_not_type = get_notification_type(options[:tl].to_i,running_time)          # Get the Notification Type     
      if tgl_not_type.class == Hash                                                 # Check if the returned is a hash with the requested information or not
        def_conf = set_defslack_conf(options[:su],options[:bn])                     # Set the Default Configuration
        slack_con = connect_s(options[:sw],def_conf)                                # Set the Slack Connection
        notif_hash = set_notif_hash(tgl_task,tgl_not_type,running_time)             # Set the Notification Hash
        main_message = get_main_message(tgl_hash,def_conf)                          # Set the Main Message
        slack_con.ping main_message, attachments: notif_hash                        # Send the Message to Slack using 'slack-notifier'
      else
        ap tgl_not_type                                                             # if it is not a hash, it will print a message
      end      
    else
       ap tgl_task                                                                  # if it is not a hash, it will print a message
    end    
  end

  desc "notif_hash", "Fill it up"
  def set_notif_hash(tgl_task,tgl_not_type,running_time)                            # Set the Notification pattern
    ap tgl_not_type    
    pretext = "Please! check the following on your Toggle Timer"
    text = "\*Task description:\* \_#{tgl_task.key?("description") ? "#{tgl_task["description"]}" : "No Description"}\_\n\*Running Time:\* #{running_time} seconds or #{Time.at(running_time).utc.strftime("%H:%M:%S")}\n\*Status:\* #{tgl_not_type[:type]}"
    color = tgl_not_type[:color]
    title = "Toggle Information"
    title_link = "https://www.toggl.com/app/timer"
    mrkdwn_in = "text","pretext"
    s_attach = [{pretext: pretext,text: text,color: color,title: title,title_link: title_link,mrkdwn_in: mrkdwn_in}]
    return s_attach
  end

  desc "connec_t", "Fill it up"
  def connect_t(toggle_tok)                                                         # Set the Connection with Toggl
    t_con = Toggl.new(toggle_tok)                               
    t_info = t_con.me(true)
    return t_info
  end

  desc "connec_s", "Fill it up"
  def connect_s(slack_hook,opt_hash)    
    notifier = Slack::Notifier.new slack_hook, opt_hash                             # Set the Connection with Slack
    return notifier
  end

  desc "get_main_message","Get the Main Message to show on Slack"
  def get_main_message(tgl_hash,def_conf)                                           # Get the Main Message to show on Slack
    s_msg = "Hi #{tgl_hash["fullname"]} #{def_conf[:channel] if def_conf[:channel].start_with? '@'} This is a friendly notification"            # Filling the s_attach hash with the related information to notify the user              
  end

  desc "set_defslack_conf", "Load Slack default Configuration"                      # Set the Default Slack Configuration
  def set_defslack_conf(s_channel="#general",s_botname="BOT_HMD_BOT",s_link_names=1)
    s_channel="#general" if s_channel.nil? 
    s_botname="BOT_HMD_BOT" if s_botname.nil?
    hash = {channel: s_channel, username: s_botname,link_names: s_link_names}
    return hash
  end

  desc "get_running_task", "Fill it up"                                             # Get the Current Running Task in Toggl
  def get_running_task(t_info)    
    if t_info.key?("time_entries")
      t_info["time_entries"].each do |i|
        return i if i.key?("stop") == false
      end
      return "This User has no Running Tasks"
    else
      return "This User has no Tasks!"
    end
  end

  desc "get_running_time", "Get Running Time"                                       # Get the task's running time in secs
  def get_running_time(t_info)                                              
    c_time_full = Time.now().localtime("+00:00")
    r_time_sec = c_time_full.to_i+t_info["duration"]
    ap "Running Time: #{r_time_sec} seconds or #{Time.at(r_time_sec).utc.strftime("%H:%M:%S")}" if @debug
    return r_time_sec.to_i    
  end

  desc "check_threshold", "Check if the task has been running for more than the expected"       # Stablish the Running time thresholds
  def get_notification_type(threshold,current_runtime)
    th_hash = set_notification_threshold(threshold)
    ap th_hash if @debug
    case current_runtime
    when th_hash[0][:min] .. th_hash[0][:max]
        return {type: "Notification",color: "#00CC00"}
    when th_hash[1][:min] .. th_hash[1][:max]
        return {type: "Warning",color: "#FFFF00"}
    when th_hash[2][:min] .. th_hash[2][:max]
        return {type: "Danger",color: "#FF8000"}
    when th_hash[3][:min] .. th_hash[3][:max]
        return {type: "Houston, We've got a Problem!",color: "#FF0000"}
    else
        return "There is no Notification for this User and Task"
    end
  end

  desc "set_notification_threshold", "Set the Notification Threshold for each type of status"   # Recursive function to set the notifications threshold
  def set_notification_threshold(th,th_plus=th,i=0,asd=Hash.new,percent=th*0.25)
    asd[i] = {min: th_plus-percent,max: (th_plus+th)-percent}
    i == 3 ? (return asd) : (set_notification_threshold(th,th_plus*=2,i+=1,asd))
  end

  desc "debug_on", "Turn Debug Mode ON"                                             # Enable and Disable Debug Mode
  def debug_on(debug=true)
    ap "Debugging is ON"
    @debug = debug
  end
end
Tracker_cli.start(ARGV)