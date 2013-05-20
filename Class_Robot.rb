class Robot
	attr_accessor :x, :y, :direction

	def initialize(robot_position)
		self.AssignPosition(robot_position)
	end

	def AssignPosition(robot_position)
		@x = robot_position[0].to_i;
		@y = robot_position[1].to_i;
		@direction = robot_position[2];
	end
end