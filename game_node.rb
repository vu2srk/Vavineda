require "ostruct"

class Node < OpenStruct

	def initialize(tag, parent, &block)
		super()

		self.parent = parent
		self.parent.children << self unless parent.nil? 
		self.tag = tag
		self.children = []

		instance_eval(&block) unless block.nil?
	end
	
	def self.root(&block)
		Node.new(:root, nil)
	end

	def self.player &block
		Node.new(:player, nil, &block)
	end

	def character(tag, &block)
		Node.new(tag, self, &block)
	end
end
