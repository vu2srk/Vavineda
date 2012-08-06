require_relative "game_tree"

class Game

	include Init

	def prompt
		print "> "
	end

	def getResponse
		gets.chomp()
	end

	def play
		@player = initPlayer
		nextStep = @start
		
		while true
			puts "\n---------------------------------------------------\n"
			scene = method(nextStep)
			nextStep = scene.call()
		end
	end

	def die
		@player.die
	end

	def crabRiddle
		crab = @level.find_by_tag(:giant_crab).askQuestion
		prompt
		answer = getResponse
		if (answer.include? "darkness")
			puts "Maman: Right answer! Go on, drink and eat as much as you want"
			@player.quenchThirst
			@player.satisfyHunger
			:takeMaman
		else
			puts "Maman: Beeeeeep. Wrong answer\n Maman starts throwing coconuts at you. Try again." 
			:crabRiddle
		end
	end

	def observeMaman
		puts "So you find out that Maman is particularly interested in staying at one spot. He doesnt want to move. You can also see something sticking out of the sand where he's sitting. What do you think you should do? Hint: Challenge him intellectually"
		prompt
		action = getResponse
		if (action.include? "move" and (action.include? "maman" or action.include? "crab"))
			puts "Maman: Yeah right. I'm not moving for you"
			:observeMaman
		elsif (action.include? "ask" and action.include? "riddle")
			puts "Maman loves to answer riddles and he has the habit of pacing while he thinks. While he paces, quickly grab what's sticking out of the ground. \n-------------------------------------------\n What you hold in your hand is a parchment with musical notes to a song. We hope you know how to read music! Do you want to sing the song?"
			prompt
			action = getResponse
			if (action.include? "yes")
				:singTheSong
			elsif (action.include? "no" or action.include? "i don't know")
				puts "You should've taken Maman when we asked you to. He knows the song You have angered him now. But he might still be willing to help you out if you agree to take him along on your journey. Do you want to?"
				prompt
				action = getResponse
				if (action.include? "yes")
					puts "Maman: Fine. I'll go with you, you silly cow. I need to get out of this place anyway. I will teach you the song of the sharks. When you sing it, one of the sharks will come to you and you can ride it.\n--------------------------------------\n Maman proceeds to teach you the song of the sharks."
                                @level.moveChild(:giant_crab, @player)
				:singTheSong
				elsif (action.include? "no")
					puts "Then all you can do is rot on this island until you can learn to read music. In other words, die. Goodbye!"
					@player.die
				else
					puts "Try again"
					:observeMaman
				end
			else
				puts "Try again"
				:observeMaman
			end
		else 
			puts "Try again"
			:observeMaman
		end
	end

	def win
		puts "Well done! You have completed the first level. We will get back to you shortly with your first task. Until then, safe voyages!"
		@player.die
	end

	def singTheSong
		puts "If you're here, it means you have the song and you can sing it! Let's do it"
		prompt
		action = getResponse
		if (action.include? "sing")
			@level.moveChild(:shark, @player)
			puts "You now have the shark to get out of the island. You have successfully passed the first level. Congratulations!"
			:win
		else
			puts "All you need to do is sing"
			:singTheSong
		end
	end

	def escapeIsland
		puts "There are sharks surrounding the island. You need to get out of the island to know what your quest is. What do you want to do"
		prompt
		action = getResponse
		if (action.include? "ask" and (action.include? "crab" or action.include? "maman"))
			maman = @player.find_by_tag(:giant_crab)
			if maman == nil
				puts "Sorry. You chose not to take Maman with you. But hey he's a nosy guy. And he wants to help. Observe him well. And maybe you'll find your answer"
				:observeMaman
			else
				puts "Maman: I will teach you the song of the sharks. When you sing it, one of the sharks will come to you and you can ride it.\n--------------------------------------\n Maman proceeds to teach you the song of the sharks."
				:singTheSong
			end
		elsif (action.include? "swim")
			puts "You're a fool. And you're also dead. Thanks for trying! Bye"
			@player.die
		else 
			puts "Nope. You can't do that. Try again."
			:escapeIsland
		end
	end

	def takeMaman
		puts "Now that you're fed, you need to find your quest. You have the option of taking Maman along with you on your quest. He knows all the secrets of Vaavineda. He could be of great help. But beware, he likes to test  you at times. Or you could leave him behind and go on your quest alone. What would you like to do?"
		prompt
		action = getResponse
		if (action.include? "take" and (action.include? "crab" or action.include? "maman"))
			@level.moveChild(:giant_crab, @player)
			puts "\n---------------------------------------------\nAlright, Maman has agreed to come with you. Now, you need to get out of this island to find your quest"
			:escapeIsland
		else
			puts "You have decided not to take Maman. Maman says 'Your loss, smarty pants'"
			:escapeIsland
		end
	end

	def islandWreck
		@level = initLevel
		puts "You are ship wrecked in the village of Ngavalus. It has been 16 hours since you had any food or water. To start with your first task, you need to get something to drink or eat. There is a palm tree loaded with coconuts that could provide you with both. But the tree is guarded by a giant coconut crab. The only other source of water is the sea. What would you like to do?"
		prompt
		action = getResponse
		if ((action.include? "talk" or action.include? "ask") and action.include? "crab")
			:crabRiddle
		elsif (action.include? "climb" and action.include? "tree")
			puts "You're insane. Cos the giant crab just had you for lunch."
			@player.die
		elsif (action.include? "drink" and action.include? "sea" and action.include? "water")
			puts "Salt water will kill you. Stop doing that and think of a better way"
			:islandWreck
		elsif (action.include? "fight" and action.include? "crab")
			puts "So long dead man. G'bye"
			@player.die
		end
	end

	def start
		puts "Welcome to Vaavineda. You are here for a reason. Your first task is to find out what you are here to do. But hurry, because the people of Vaavineda need you. Whatever you do, remember this: You are important. Play it right, and  you will achieve greatness. One wrong move and you will end up dead - Another lost hope for the people. Do you want to start on your adventure?"
		prompt
		action = getResponse
		if (action.include? "yes")
			@start = :islandWreck
			play
		elsif (action.include? "no")
			puts "You are not born great. You are made great. Goodbye"
			Process.exit(0)
		else 
			puts "Dude, please don't waste our time. It's a simple yes or no question.\n-------------------------------------\n"
			start 
		end
	end

	def getPlayer
		@player
	end

end

g = Game.new
g.start

