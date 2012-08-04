require_relative "game_node"

player = Node.player do
		self.isThirsty = true
		self.isHungry = false
		self.assets = {}

		def die
			puts "You failed"
			Process.exit(0)
		end

		def addAsset asset
			self.assets << asset
		end
	end

level1 = Node.root do
		character(:shark) do
			def eat_player
				player.send(:die)
			end			
		end
		character(:giant_crab) do
			def grant_access_to_climb_tree
				player.send(:addAsset, "tree")
			end
		end
	end

puts player
puts level1
