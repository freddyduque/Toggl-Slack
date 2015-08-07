# Toggl and Slack integrated application
Backend application in ruby to be executed every certain time, and based on a predefined criteria, be able to send notifications to the people that don't fulfill it.

##Applications Involved

**Toggl:** Web application to track the execution time of certain tasks or projects.

**Slack:** Application to enhance in a better way the communication between teams. This Application will prompt the notifications to the team members that do not fulfill the previous criteria.

**Crontab:** It will be the one in charge to periodically execute the ruby application.

**Ruby:** The result from Toggl will be analyzed using this language and it will trigger the cue to Slack to display the notifications based on the previous criteria.

##Procedure

First understand how Toggl works, create an account, and based on the token authentication method run a couple of tests.

Testing the authentication API using `curl` 

Token Authentication
```shell
curl -v -u xxxxxx:api_token -X GET https://www.toggl.com/api/v8/me
```

To understand in a better way the `curl` output, `jazor` was used to parse the result.
```shell
sudo gem install jazor
sudo gem install bundler
```

Using `jazor` to understand the output:
```shell
curl -v -u xxxxxx:api_token -X GET https://www.toggl.com/api/v8/me?with_related_data=true | jazor -c
```

executing the ruby application:
```shell
ruby testting.rb
sudo gem install faraday
sudo gem install awesome_print
```
