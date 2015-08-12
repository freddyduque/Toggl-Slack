require_relative 'togglV8'

class User
	# Initialize the User Class
	def initialize(token)
		connection = Toggl.new token
		@user=connection.me(true)
	end

	# Get the Current Running Task in Toggl
	def get_running_task(threshold)		
		if @user.key?("time_entries")
			@user["time_entries"].each do |i|
				if i.key?("stop") == false
					i.merge!({"z_threshold" => threshold})
					i.merge!({"z_running_time" => get_running_time(i)})
					i.merge!(set_notification_type(i))
					return i
				end
			end
			return {"z_type" => "error", "z_description" => "This User has no Running Tasks", "z_time" => "#{Time.new}"}
		else
			return {"z_type" => "error", "z_description" => "This User has no Tasks", "z_time" => "#{Time.new}"}
		end
	end

	# Get the User Name
	def get_user_fullname()
		@user["fullname"]
	end	

	# Get the task's running time in secs
	def get_running_time(running_task)
		current_time = Time.now().localtime("+00:00")
		running_time = current_time.to_i+running_task["duration"]
		running_time_verbose = Time.at(running_time).utc.strftime("%H:%M:%S")
		return running_time.to_i
	end

	# Set the Notification Type
	def set_notification_type(running_task)
		threshold_hash = set_notification_threshold(running_task["z_threshold"])
		case running_task["z_running_time"]
		when threshold_hash[0][:min] .. threshold_hash[0][:max]
			return {"z_status" => "Notification","z_color" => "#00CC00"}
		when threshold_hash[1][:min] .. threshold_hash[1][:max]
			return {"z_status" => "Warning","z_color" => "#FFFF00"}
		when threshold_hash[2][:min] .. threshold_hash[2][:max]
			return {"z_status" => "Danger","z_color" => "#FF8000"}
		when threshold_hash[3][:min] .. threshold_hash[3][:max]
			return {"z_status" => "Houston, We've got a Problem!","z_color" => "#FF0000"}
		else
			return {"z_type" => "error", "z_description" => "There's no Notification for this User and Task", "z_time" => "#{Time.new}"}
		end
	end

	# Recursive function to set the notifications threshold
	def set_notification_threshold(threshold,threshold_plus=threshold,i=0,threshold_hash=Hash.new,percent=threshold*0.25)
		threshold_hash[i] = {min: threshold_plus-percent,max: (threshold_plus+threshold)-percent}
		i == 3 ? (return threshold_hash) : (set_notification_threshold(threshold,threshold_plus*=2,i+=1,threshold_hash))
	end
end