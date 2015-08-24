require_relative 'togglV8'

class User
  attr_accessor :information, :time_entry, :notify

  # Initialize the User Class
  def initialize(token=nil,threshold=3600)

    threshold = number_or_nil(threshold)
    @information = Hash.new {|h,k| h[k]=[]}

    # Check Threshold Value
    unless threshold.nil?
      @information["z_error"] << {code: -1, description: "Time Limit is lower than 1 second"} if threshold < 1
    else
      @information["z_error"] << {code: -1, description: "Time Limit is not Integer"}
    end

    # Check Token Value
    unless token.nil?
      if token == ""
        @information["z_error"] << {code: -2, description: "User Token is empty"}
      else
        connection = Toggl.new token
        temp = connection.me(true)
        @information["z_error"] << {code: -2, description: "User doesn't exist"} if temp.nil?
      end
    else
      @information["z_error"] << {code: -2, description: "No Arguments"}
    end

    unless @information.has_key?("z_error")
      @information = {"id" => temp["id"], "email" => temp["email"], "fullname" => temp["fullname"], "z_threshold" => threshold}
      @information["time_entry"] = @time_entry = running_task(temp["time_entries"],threshold)
    end
  end

  # Check if a string is Numeric or not, return the corresponding Number or nil if it's String
  def number_or_nil(string)
    Integer(Float(string || ''))
  rescue ArgumentError
    nil
  end

  # Get the Current Running Task in Toggl
  def running_task(time_entries,threshold)
    unless time_entries.nil?
      time_entries.each do |i|
        if i.key?("stop") == false
          i["z_running_time"] = running_time(i)
          i["z_notification"] = @notify = notification(i,threshold)
          return i
        end
      end
    end
    return false
  end

  # Get the task's running time in secs
  def running_time(task)
    Time.now().localtime("+00:00").to_i+task["duration"]
  end

  # Set the Notification Type
  def notification(task,threshold)
    threshold_hash = notification_threshold(threshold)
    case task["z_running_time"]
    when threshold_hash[0]["min"] .. threshold_hash[0]["max"]
      return {"z_range" => threshold_hash[0],"z_type" => "Notification","z_color" => "#00CC00"}
    when threshold_hash[1]["min"] .. threshold_hash[1]["max"]
      return {"z_range" => threshold_hash[1],"z_type" => "Warning","z_color" => "#FFFF00"}
    when threshold_hash[2]["min"] .. threshold_hash[2]["max"]
      return {"z_range" => threshold_hash[2],"z_type" => "Danger","z_color" => "#FF8000"}
    when threshold_hash[3]["min"] .. threshold_hash[3]["max"]
      return {"z_range" => threshold_hash[3],"z_type" => "Houston, We've got a Problem!","z_color" => "#FF0000"}
    else
      return false                                     # There's no Notification for this User and Task
    end
  end

  # Recursive function to set the notifications threshold
  def notification_threshold(threshold,threshold_plus=threshold,i=0,threshold_hash=Hash.new,percent=threshold*0.25)
    threshold_hash[i] = {"min" => threshold_plus-percent,"max" => (threshold_plus+threshold)-percent}
    i == 3 ? (return threshold_hash) : (notification_threshold(threshold,threshold_plus*=2,i+=1,threshold_hash))
  end
end