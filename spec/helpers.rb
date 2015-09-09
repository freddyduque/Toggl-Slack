#!/usr/bin/ruby

module Helpers

  def right_user_with_time(time)
    (User.new "d396742070d0b5e3ae602c7baca8bb3d",time).information
  end
  def right_user_with_no_time
    (User.new "d396742070d0b5e3ae602c7baca8bb3d").information
  end
  def user_with_no_arguments
    User.new.information
  end
  def wrong_user_with_time(time)
    (User.new "aseaseqwwqrsqwcqwdfwdwqqeeaeqeqwe",time).information
  end
  def wrong_user_with_no_time
    (User.new "aseaseqwwqrsqwcqwdfwdwqqeeaeqeqwe").information
  end

  def supervisor_with_no_arguments
    (Supervisor.new).connection
  end
  def supervisor_with_webhook(webhook)
    (Supervisor.new webhook).connection
  end
  def supervisor_with_bad_url
    supervisor "https://hooks.slack.com/services"
  end
  def supervisor_with_bad_token
    supervisor "https://hooks.slack.com/services/T0887E294/B08K2UK0T/S2GDb24rJ"
  end
  def supervisor_with_no_token
    supervisor "https://hooks.slack.com/services/T0887E294/B08K2UK0T"
  end
  def supervisor(webhook)
    (Supervisor.new webhook).send("testing message")
  end
end