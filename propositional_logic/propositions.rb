class Proposition 
  def initialize(args)
    @args = args
  end

  def ==(arg)
    self.print == arg.print
  end

  def atomic? 
    false
  end

  def implies(arg)
    PropositionImplies([self,arg])
  end

  def substitute(q,r)
    if atomic? 
      if self == q
        r
      else
        self
      end
    else
      new_args = @args.map{|arg| arg.substitute(q,r)}
      self.class.new(new_args)
    end
  end
end

class PropositionAtomic < Proposition
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def print
    name
  end
  
  def atomic?
    true
  end
end

class PropositionNot < Proposition
  def print
    "(\\neg #{args.first.print})"
  end
end

class PropositionAnd < Proposition
  def print
    "(#{@args.map(&:print).join(" \\wedge ")})"
  end
end

class PropositionOr < Proposition
  def print
    "(#{@args.map(&:print).join(" \\vee ")})"
  end
end

class PropositionImplies < Proposition
  def print
    "(#{@args.map(&:print).join(" \\implies ")})"
  end
end

def and(*args)
  PropositionAnd.new(args)
end

def or(*args)
  PropositionOr.new(args)
end

def not(*args)
  PropositionNot.new(args)
end

def implication(*args)
  PropositionImplies.new(args)
end

def atom(name)
  PropositionAtomic.new(name)
end



