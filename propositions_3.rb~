class Proposition
	def implies(other)
		ImpliesProposition.new(self,other)
	end

	def copy 
		new_one = self.class.new 
		if self.respond_to?(:args)
			new_one.args = self.args.map{|arg| arg.copy}
		elsif self.respond_to?(:name)
			new_one.name = self.name
		end
	end
	
	def holds?(knowns)
		
		if knowns.include?(self)
			return true 
		end
		modus_ponens = knowns.select{|known| known.is_a?(ImpliesProposition) && known.conc == self && known.hyp.holds?(knowns)}
		if !modus_ponens.empty?
#			knowns += modus_ponens.map{|imp| imp.hyp}
			return true
		end

	end
end

class AtomicProposition < Proposition 
	attr_accessor :name 

	def initialize(name)
		@name = name
	end
	
	def ==(other)
		self.name == other.name 
	end

end

class ImpliesProposition < Proposition
	attr_accessor :args 

	def initialize(hyp,conc)
		@args = [hyp,conc]
	end

	def hyp
		@args[0]
	end

	def conc 
		@args[1]
	end
	
	def ==(other)
		self.class == other.class && self.args == other.args
	end

end



def atom(name)
	AtomicProposition.new(name)
end
