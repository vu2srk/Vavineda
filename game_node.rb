require "ostruct"

class Node < OpenStruct

	def initialize(tag, parent, &block)
		super()

		puts tag

		self.parent = parent
		self.parent.children << self unless parent.nil? 
		self.tag = tag
		self.children = []

		instance_eval(&block) unless block.nil?
	end
	
	def self.root(&block)
		Node.new(:root, nil, &block)
	end

	def self.player &block
		Node.new(:player, nil, &block)
	end

	def character(tag, &block)
		c = Node.new(tag, self)
		c.instance_eval(&block) if block_given?
	end
end
