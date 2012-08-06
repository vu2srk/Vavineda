require_relative "game_node"

module Init

	def initPlayer 
	  Node.player do
	    self.isThirsty = true
	    self.isHungry = true
	    self.assets = {}

		def die
		  Process.exit(0)
		end

		def addAsset asset
		  self.assets << asset
		end
		
		def quenchThirst 
		  puts "You have quenched your thirst. You won't find water for a long time. So make sure you drink enough."
		  self.isThirsty = false
		end

		def satisfyHunger
		  puts "Good. Your stomach's full. For now"
		  self.isHungry = false
		end
	  end
	end

	def initLevel	
	  Node.root do
	    character(:shark) do
	    	def eat_player
		  player.send(:die)
		end			
	    end
	    character(:giant_crab) do
		def grant_access_to_climb_tree
		  player.send(:addAsset, "tree")
		end

		def askQuestion
		  puts "Giant Crab: Waddup yo. I'm Maman. Here's the deal. Answer the question and you can have the nuts. Get it wrong, and I'll have yours. Muhahaha. Here goes: The more you have of it, the less you see. What is it?"
		end
	    end
	  end
	end

end


