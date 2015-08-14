require_relative 'togglV8'

class User
  attr_accessor :information, :time_entry, :notify

  def initialize(token,threshold=3600)                 # Initialize the User Class
    connection = Toggl.new token
    temp=connection.me(true)    
    @threshold=threshold

    @information = Hash["id" => temp["id"], "email" => temp["email"], "fullname" => temp["fullname"], "z_threshold" => threshold]
    @information["time_entry"] = @time_entry = running_task(temp["time_entries"])    
  end

  # Get the Current Running Task in Toggl
  def running_task(time_entries)
    unless time_entries.nil?
      time_entries.each do |i|
        if i.key?("stop") == false
          i["z_running_time"] = running_time(i)
          i["z_notification"] = @notify = notification(i)
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
  def notification(task)
    threshold_hash = notification_threshold(@threshold)
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