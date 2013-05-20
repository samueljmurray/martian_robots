module ControlParams

	DIRECTIONS = ["N","W","S","E"]
	DIRECTIONS_FUNC = {"N" => [0,1], "W" => [-1,0], "S" => [0,-1], "E" => [1,0] }
	# ADDING INSTRUCTIONS:
	# - Instructions should be Symbol type, maximum 29 characters in length
	# - Instruction descriptions should be maximum 80 characters in length
	INSTRUCTIONS = {
		L: {
			Description: "Turn the robot 90 degrees anti-clockwise on its current position",
			Method: lambda do |x,y,direction|
				if direction == DIRECTIONS.last
					new_direction = DIRECTIONS.first
				else
					new_direction = DIRECTIONS[DIRECTIONS.index(direction) + 1]
				end
				return x,y,new_direction
			end
		},
		# Turn the robot 90 degrees clockwise on its current position
		R: {
			Description: "Turn the robot 90 degrees clockwise on its current position",
			Method: lambda do |x,y,direction|
				if direction == DIRECTIONS.first
					new_direction = DIRECTIONS.last
				else
					new_direction = DIRECTIONS[DIRECTIONS.index(direction) - 1]
				end
				return x,y,new_direction
			end
		},
		# Move the robot one grid space in the direction it is facing
		F: {
			Description: "Move the robot one grid space in the direction it is facing",
			Method: lambda do |x,y,direction|
				new_x = x + (DIRECTIONS_FUNC[direction][0] * 1)
				new_y = y + (DIRECTIONS_FUNC[direction][1] * 1)
				return new_x,new_y,direction
			end
		}
	}

end