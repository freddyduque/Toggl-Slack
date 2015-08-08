#!/bin/sh
tl=60 #tl=3600 #change this to 1 hour = 3600 secs
while true; do
	./trkr.rb tknzr --sw="add your webhook URL here" --tt="add your toggl token here" --tl="add the time limit (in seconds) here, every checkpoint or threshold" [--su]="add the slack username or channel to notify here, default: '#general', DM: '@slack.user'" [--bn]="add your personalized Bot Name, default: 'HMD_BOT'" [--db]="add true here if you want to activate debug mode, default: off"   
	sleep $tl; 
done