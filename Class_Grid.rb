require "./Module_ControlParams.rb"

class Grid
	include ControlParams

	attr_reader :width, :height, :robots, :lost_robots

	def initialize
		@width = false
		@height = false
		@robots = Array.new
		@lost_robots = Hash.new
	end

	def AssignGridSize gridsize_input
		gridsize = gridsize_input.split(" ")
		if self.ValidateGridSize(gridsize)
			@width = gridsize[0].to_i
			@height = gridsize[1].to_i
			return true
		else
			return false
		end
	end

	def ValidateGridSize gridsize
		invalid = false
		gridsize_format_error_raised = false
		gridsize_size_error_raised = false
		# Checks number of values inputted
		if gridsize.count != 2
			Utils::RaiseGridError(:gridsize,"Wrong number of values!")
			invalid = true
		end
		# Checks that inputted values are positive integers
		gridsize.each do |dim|
			unless gridsize_format_error_raised
				if dim != dim.match(/\d+/).to_s
					Utils::RaiseGridError(:gridsize,"Grid dimensions need to be positive whole numbers!")
					invalid = true
					gridsize_format_error_raised = true
				end
			end
		end
		# Checks that inputted values do not exceed 50
		gridsize.each do |dim|
			unless gridsize_size_error_raised
				if dim.to_i > 50
					Utils::RaiseGridError(:gridsize,"A grid cannot be larger than 50 by 50!")
					invalid = true
					gridsize_size_error_raised = true
				end
			end
		end
		# Return
		if invalid 
			return false
		else 
			return true
		end
	end

	def AddRobotToGrid robot_position_input
		robot_position = robot_position_input.upcase.split(" ")
		if self.ValidateRobotPosition(robot_position)
			@robots << Robot.new(robot_position)
			return true
		else
			return false
		end
	end

	def ValidateRobotPosition robot_position
		invalid = false
		position_format_error_raised = false
		position_size_error_raised = false
		position_offgrid_error_raised = false
		# Checks number of values inputted
		if robot_position.count != 3
			Utils::RaiseGridError(:robot_position,"Wrong number of values!")
			invalid = true
		end
		# Checks that inputted values are positive integers
		robot_position.each do |pos|
			unless position_format_error_raised
				if pos != pos.match(/\d+/).to_s && (pos == robot_position[0] || pos == robot_position[1])
					Utils::RaiseGridError(:robot_position,"Coordinates need to be positive whole numbers!")
					invalid = true
					position_format_error_raised = true
				end
			end
		end
		# Checks that coordinates are within the bounds of the grid
		robot_position.each do |pos|
			unless position_offgrid_error_raised
				if ((pos.to_i > self.width || pos.to_i < 0) && pos == robot_position[0]) || ((pos.to_i > self.height || pos.to_i < 0) && pos == robot_position[1])
					Utils::RaiseGridError(:robot_position,"Those coordinates aren't within the bounds of the grid!")
					invalid = true
					position_offgrid_error_raised = true
				end
			end
		end
		# Checks that the direction inputted is valid
		if robot_position[2]
			unless ControlParams::DIRECTIONS.include? robot_position[2]
				dirs = ControlParams::DIRECTIONS.join(', ')
				Utils::RaiseGridError(:robot_position,"Direction needs to be one of the following: " + dirs)
				invalid = true
			end
		else 
			Utils::RaiseGridError(:robot_position,"A robot's position needs to include the direction it is facing!")
		end
		# Return
		if invalid 
			return false
		else 
			return true
		end
	end

	def ProcessInstruction robot_instruction_input
		robot_instruction = robot_instruction_input.upcase.split("")
		if self.ValidateRobotInstruction(robot_instruction)
			robot_new_x = robots.last.x
			robot_new_y = robots.last.y
			robot_new_direction = robots.last.direction
			# Loop through each instruction
			robot_instruction.each do |inst|
				scent_detected = false
				robot_last_x,robot_last_y,robot_last_direction = robot_new_x,robot_new_y,robot_new_direction
				# Checks if robot's position has a scent
				lost_robots.each_pair do |lost_robot_num,lost_coords|
					if lost_coords[0] == robot_last_x && lost_coords[1] == robot_last_y
						scent_detected = lost_robot_num
					end
				end
				# Performs the instruction
				robot_new_x,robot_new_y,robot_new_direction = ControlParams::INSTRUCTIONS[inst.to_sym][:Method].call robot_last_x,robot_last_y,robot_last_direction
				# If instruction would take the robot off the grid
				if (robot_new_x > self.width || robot_new_x < 0) || (robot_new_y > self.height || robot_new_y < 0)
					if scent_detected
						# Fail instructions and return message saying that a scent was detected
						puts Utils::AddStyle("MESSAGE FROM ROBOT " << robots.length.to_s << ": \"NOOO! I won't do it! I won't make the same mistake as Robot " << scent_detected.to_s << "!\"",:fg_magenta,:bold)
						return false
					else
						# Pass instructions and return message saying that the robot was lost
						puts Utils::AddStyle("LOST! Robot " << robots.length.to_s << " fell off the grid at coordinates " << robot_last_x.to_s << " " << robot_last_y.to_s << " :( Fortunately, Robot " << robots.length.to_s << " had a social conscience because it left a scent at this spot to prevent other robots from suffering the same fate. How kind!",:fg_magenta,:bold)
							lost_robots[robots.length] = [robot_last_x,robot_last_y]
						SetRobotPosition robot_last_x,robot_last_y,robot_last_direction
						return true
					end
				end
			end
			# Pass instructions and return robot's final position
			puts Utils::AddStyle("ROBOT " << robots.length.to_s << " FINAL POSITION: " << robot_new_x.to_s << " " << robot_new_y.to_s << " " << robot_new_direction << "\n",:fg_green,:bold)
			SetRobotPosition robot_new_x,robot_new_y,robot_new_direction
			return true
		end
	end

	def ValidateRobotInstruction robot_instruction
		invalid = false
		robot_instruction_content_error_raised = false
		robot_instruction_content_error_collector = Array.new
		# Checks that the inputted instruction string doesn't exceed 100 instructions
		if robot_instruction.count > 100
			Utils::RaiseGridError(:robot_instruction_form,"Robots are lazy and won't accept more than 100 instructions!")
			invalid = true
		end
		# Checks that all of the values inputted are valid instructions
		robot_instruction.each do |inst|
			unless ControlParams::INSTRUCTIONS.has_key? inst.to_sym
				unless robot_instruction_content_error_collector.include? inst
					Utils::RaiseGridError(nil,inst + " is not a valid instruction for these robots!\n")
					invalid = true
					robot_instruction_content_error_raised = true
					robot_instruction_content_error_collector << inst
				end
			end
		end
		# Return
		if invalid
			if robot_instruction_content_error_raised
				Utils::RaiseGridError(:robot_instruction_content,"")
			end
			return false
		else 
			return true
		end
	end

	def SetRobotPosition x,y,direction
		robots.last.x = x
		robots.last.y = y
		robots.last.direction = direction
	end

	
end