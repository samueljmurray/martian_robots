require "./Class_Grid.rb"
require "./Class_Robot.rb"
require "./Module_Utils.rb"

include Utils
# Resize the console to 40 lines by 116 lines, make default terminal colors white text on black background and disable keyboard input echoing and carriage return
print %x(printf "\e[8;40;116t" ; printf "\033[0;37;40m" ; stty -echo igncr)
# Display welcome scree
puts Utils::AddStyle(Utils::ASCII_MARTIANROBOT,:bold,:fg_cyan)
print Utils::AddStyle(Utils::ASCII_ROBOT,:bold,:fg_cyan)
puts Utils::AddStyle(Utils::ASCII_CONTROLDECK,:bold,:fg_cyan)
print "                                                    "
"W E L C O M E !".split("").each do |c|
	print Utils::AddStyle(c,:bold,:bg_cyan,:fg_black)
	sleep 0.2
end
sleep 0.5
# Wipe the screen, make default terminal colors white text on black background, clear screen to cover with new colors, discard any keyboard input that may have been captured while the welcome screen displayed and re-enable keyboard input echoing and carraige return
print %x(tput reset ; printf "\033[0;37;40m" ; clear ; read -t 1 -n 10000 discard ; stty echo -igncr)
# List robot instructions and special commands
puts Utils::AddStyle(Utils::DoHelp(),:fg_cyan)
puts "\n"

# Create grid object
thegrid = Grid.new

# Get grid size
got_gridsize = false
until (got_gridsize)
	print Utils::AddStyle("Grid size(W H): ",:fg_cyan)
	gridsize_input = gets.chomp
	unless Utils::CommandCheck(gridsize_input,thegrid)
		if thegrid.AssignGridSize gridsize_input
			puts Utils::AddStyle("Grid created\n",:fg_green)
			got_gridsize = true
		end
	end
end

#Begin robots loop
no_escape = true
while (no_escape)
	# Add robot and get its position
	got_robotpos = false
	until (got_robotpos)
		print Utils::AddStyle("Robot " << (thegrid.robots.length + 1).to_s << " position (X Y DIR): ",:fg_cyan)
		robotpos_input = gets.chomp
		unless Utils::CommandCheck(robotpos_input,thegrid)
			if thegrid.AddRobotToGrid robotpos_input
				got_robotpos = true
			end
		end
	end
	# Get instructions and move robot
	got_robotinst = false
	until (got_robotinst)
		print Utils::AddStyle("Instructions for Robot " << thegrid.robots.length.to_s << ": ",:fg_cyan)
		robotinst_input = gets.chomp
		unless Utils::CommandCheck(robotinst_input,thegrid)
			if thegrid.ProcessInstruction robotinst_input
				got_robotinst = true
			end
		end
	end
end
