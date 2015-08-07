# Toggl and Slack integrated application
Backend application in ruby to be executed every certain time, and based on a predefined criteria, be able to send notifications to the people that don't fulfill it.

##Applications Involved

**Toggl:** Web application to track the execution time of certain tasks or projects.

**Slack:** Application to enhance in a better way the communication between teams. This Application will prompt the notifications to the team members that do not fulfill the previous criteria.

**Crontab:** It will be the one in charge to periodically execute the ruby application.

**Ruby:** The result from Toggl will be analyzed using this language and it will trigger the cue to Slack to display the notifications based on the previous criteria.

## Requires

``` shell
sudo gem install jazor
sudo gem install bundler
sudo gem install faraday
sudo gem install awesome_print
sudo gem install slack-notifier
```
##Procedure
