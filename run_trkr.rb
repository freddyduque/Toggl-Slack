#!/usr/bin/ruby

require 'awesome_print'
require 'json'

file = File.read(Dir.pwd+'/conf/app.conf')
data_hash = JSON.parse(file)

webhook=data_hash["webhook"]
times_limit=data_hash["time_limit"]
debug_mode="" 							# Set this true if you want to turn ON the debug mode
bot_name=""								# Set the BOT NAME

tl=60 									#tl=3600 #change this to 1 hour = 3600 secs
while (true)
	data_hash["users"].each do |x|
		ap "[#{Time.new}] Checking Slack User: #{x["slack_username"]}, Toggl Token: #{x["toggl_token"]}"
		`./trkr.rb tknzr --sw="#{webhook}" --tt="#{x["toggl_token"]}" --su="#{x["slack_username"]}" --tl=#{tl} --bn="#{bot_name}" --db=#{debug_mode}`
	end
	sleep(tl)
end