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

	def find_by_tag(tag)
    		return self if self.tag == tag

    		children.each do|c|
      			res = c.find_by_tag(tag)
      			return res unless res.nil?
    		end

    		return nil
  	end

	def moveChild(tag, to)
		child = find_by_tag(tag)
		child.parent.children.delete(child)
		child.parent = to
		child.parent.children << child
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
