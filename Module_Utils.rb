require "./Module_ControlParams.rb"
module Utils
	include ControlParams

    ASCII_MARTIANROBOT = "
                                                                                                                    
                                                                                                                    
  .88b  d88.  .d8b.  d8888b. d888888b d888888b  .d8b.  d8b   db         d8888b.  .d88b.  d8888b.  .d88b.  d888888b  
  88'YbdP`88 d8' `8b 88  `8D `~~88~~'   `88'   d8' `8b 888o  88         88  `8D .8P  Y8. 88  `8D .8P  Y8. `~~88~~'  
  88  88  88 88ooo88 88oobY'    88       88    88ooo88 88V8o 88         88oobY' 88    88 88oooY' 88    88    88     
  88  88  88 88~~~88 88`8b      88       88    88~~~88 88 V8o88         88`8b   88    88 88~~~b. 88    88    88     
  88  88  88 88   88 88 `88.    88      .88.   88   88 88  V888         88 `88. `8b  d8' 88   8D `8b  d8'    88     
  YP  YP  YP YP   YP 88   YD    YP    Y888888P YP   YP VP   V8P         88   YD  `Y88P'  Y8888P'  `Y88P'     YP     "

	ASCII_CONTROLDECK = "
        .o88b.  .d88b.  d8b   db d888888b d8888b.  .d88b.  db              d8888b. d88888b  .o88b. db   dD          
       d8P  Y8 .8P  Y8. 888o  88 `~~88~~' 88  `8D .8P  Y8. 88              88  `8D 88'     d8P  Y8 88 ,8P'          
       8P      88    88 88V8o 88    88    88oobY' 88    88 88              88   88 88ooooo 8P      88,8P            
       8b      88    88 88 V8o88    88    88`8b   88    88 88              88   88 88~~~~~ 8b      88`8b            
       Y8b  d8 `8b  d8' 88  V888    88    88 `88. `8b  d8' 88              88  .8D 88.     Y8b  d8 88 `88.          
        `Y88P'  `Y88P'  VP   V8P    YP    88   YD  `Y88P'  Y88888P         Y8888D' Y88888P  `Y88P' YP   YD          
                                                                                                                    
                                                                                                                    
                                                                                                                    "
	ASCII_ROBOT = "      

                                                        _____                                                       
                                                       /_____\\                                                      
                                                  ____[\\`---'/]____                                                 
                                                 /\\ #\\ \\_____/ /# /\\                                                
                                                /  \\# \\_.---._/ #/  \\                                               
                                               /   /|\\  |   |  /|\\   \\                                              
                                              /___/ | | |   | | | \\___\\                                             
                                              |  |  | | |---| | |  |  |                                             
                                              |__|  \\_| |_#_| |_/  |__|                                             
                                              //\\\\  <\\ _//^\\\\_ />  //\\\\                                             
                                             \\||/  |\\//// \\\\\\\\/|  \\||/                                              
                                                    |   |   |   |                                                   
                                                    |---|   |---|                                                   
                                                    |---|   |---|                                                   
                                                    |   |   |   |                                                   
                                                    |___|   |___|                                                   
                                                    /   \\   /   \\                                                   
                                                   |_____| |_____|                                                  
                                                   |HHHHH| |HHHHH|                                                  
                                                                                                                    
                                                                                                                    "
	
	ASCII_BYE = "





                                              d8888b. db    db d88888b db 
                                              88  `8D `8b  d8' 88'     88 
                                              88oooY'  `8bd8'  88ooooo YP 
                                              88^^^b.    88    88^^^^^    
                                              88   8D    88    88.     db 
                                              Y8888P'    YP    Y88888P YP 
"
	SPECIAL_COMMANDS = {
		# ADDING SPECIAL COMMANDS:
		# - Special commands should be Symbol type, maximum 29 characters in length
		# - Special command descriptions should be maximum 80 characters in length
		exit: {
			Description: "Exit the program",
			Method: lambda do |thegrid|
				print %x(tput reset ; printf "\033[0;37;40m" ; clear ; stty -echo igncr)
				puts AddStyle(ASCII_ROBOT,:fg_cyan,:bold)
				puts AddStyle(ASCII_BYE,:fg_cyan,:bold)
				sleep 2
				puts %x(clear ; stty echo -igncr ; printf "\033[0m")
				exit
			end
		},
		where: {
			Description: "Lists the positions of all robots",
			Method: lambda do |thegrid|
				if thegrid.robots.length > 0
					puts Utils::AddStyle("\nALL ROBOTS",:bold)
					puts "------------------"
					thegrid.robots.each_with_index do |robot,robot_num|
						robot_num = robot_num+1
						print "Robot " << robot_num.to_s << ": "
						if thegrid.lost_robots.has_key? robot_num
							print "LOST! Last seen at "
						end
						puts robot.x.to_s << " " << robot.y.to_s << " " <<robot.direction
					end
					puts ""
				else
					puts "\nNo robots on the grid yet!\n\n"
				end
			end
		},
		lost: {
			Description: "Lists the positions of all robots that have been lost",
			Method: lambda do |thegrid|
				if thegrid.lost_robots.length > 0
					puts Utils::AddStyle("\nLOST ROBOTS",:bold)
					puts "-----------"
					thegrid.lost_robots.each_pair do |robot_num,coords|
						print "Robot " << robot_num.to_s << ": "
						puts "Last seen at " << coords.fetch(0).to_s << " " << coords.fetch(1).to_s
					end
					puts ""
				else
					puts "\nNo robots have been lost!\n\n"
				end
			end
		},
		ongrid: {
			Description: "Lists the positions of all robots that are on the grid",
			Method: lambda do |thegrid|
				if thegrid.robots.length == thegrid.lost_robots
					puts Utils::AddStyle("\nALL ROBOTS",:bold)
					puts "------------------"
					thegrid.robots.each_with_index do |robot,robot_num|
						robot_num = robot_num+1
						unless thegrid.lost_robots.has_key? robot_num
							puts "Robot " << robot_num.to_s << ": " << robot.x.to_s << " " << robot.y.to_s << " " <<robot.direction
						end
					end
					puts ""
				else
					puts "\nNo robots are on the grid!\n\n"
				end
			end
		},
		grid: {
			Description: "Displays the size of the grid",
			Method: lambda do |thegrid|
				if thegrid.width && thegrid.height
					puts "\nThe grid is " << thegrid.width.to_s << " wide and " << thegrid.height.to_s << " high.\n\n"
				else
					puts "\nNo grid set yet!\n\n"
				end
			end
		},
		help: {
			Description: "Lists the robot instructions and special commands",
			Method: lambda do |thegrid|
				puts AddStyle(DoHelp(),:fg_cyan)
			end
		}
	}

	def DoHelp
		rtn_str = ""
		rtn_str << "   --------------------------------------------------------------------------------------------------------------   
  |                                            ROBOT INSTRUCTIONS                                                |  
   --------------------------------------------------------------------------------------------------------------   
  | INSTRUCTION                  FUNCTION                                                                        |  "
		ControlParams::INSTRUCTIONS.each_pair do |inst_name,inst|
			rtn_str << "  | " << inst_name.to_s << " " * (29 - inst_name.to_s.length) << inst[:Description] << " " * (80 - inst[:Description].length) << "|  "
		end
		rtn_str << "   --------------------------------------------------------------------------------------------------------------   
  |                                            SPECIAL COMMANDS                                                  |  
   --------------------------------------------------------------------------------------------------------------   
  | COMMAND                      FUNCTION                                                                        |  "
		SPECIAL_COMMANDS.each_pair do |comm_name,comm|
			rtn_str << "  | " << comm_name.to_s << " " * (29 - comm_name.to_s.length) << comm[:Description] << " " * (80 - comm[:Description].length) << "|  "
		end
		rtn_str << "   --------------------------------------------------------------------------------------------------------------   "
		return rtn_str
	end

	def CommandCheck input,thegrid
		SPECIAL_COMMANDS.each_pair do |comm_name,comm|
			if comm_name.to_s == input
				comm[:Method].call thegrid
				return true
			end
		end
		return false
	end

	def RaiseGridError type,message
		print "[ " << AddStyle("ERROR",:fg_red,:bold) << " ] "
		print AddStyle(message.upcase,:fg_red)
		case type
		when :gridsize
			puts " Please give a gridsize in the format: [WIDTH] [HEIGHT], for example: 10 20 (Maximum is 50 50)"
		when :robot_position
			puts " Please give a robot position in the format: [X] [Y] [DIRECTION: N/W/S/E], for example: 2 3 N"
		when :robot_instruction_form
			print " Instructions need to be given as a string of capital letters, for example: "
			ControlParams::INSTRUCTIONS.each_pair do |inst,inst_content|
				print inst
			end
			puts ""
		when :robot_instruction_content
			puts "The following are valid instructions: "
			ControlParams::INSTRUCTIONS.each_pair do |inst,inst_content|
				puts "          #{inst}: #{inst_content[:Description]}"
			end
		end
	end

	def AddStyle string,*styles
		styles_table = {
			reset: "0",
			bold: "1",
			reverse: "7",
			fg_black: "30",
			fg_red: "31",
			fg_green: "32",
			fg_brown: "33",
			fg_blue: "34",
			fg_magenta: "35",
			fg_cyan: "36",
			fg_white: "37",
			bg_black: "40",
			bg_red: "41",
			bg_green: "42",
			bg_brown: "43",
			bg_blue: "44",
			bg_magenta: "45",
			bg_cyan: "46",
			bg_white: "47"
		}
		rtn_str = "\e["
		styles.each do |style|
			rtn_str << styles_table[style]
			unless style == styles.last
				rtn_str << ";"
			end
		end
		rtn_str << "m" << string << "\e[0;37;40m"
		return rtn_str
	end

end