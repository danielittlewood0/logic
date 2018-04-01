class ProofStep
  attr_accessor :hypotheses, :conclusion

  def valid?

  end
end


class Proposition

  def ==(other)
    self.latex == other.latex
  end

  def implies(b)
    ImplicativeProposition.new(self,b)
  end

  def substitute(a,b)
    if self.respond_to?(:args)
      @args.map!{|arg| arg.substitute(a,b)}
      return self
    else
      if self == a
        return b
      else
        return self
      end
    end
  end

  def multisub(hash)
    hash.each{|k,v| self.substitute(k,v)}
    return self
  end

end

class AtomicProposition < Proposition
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def latex
    @name
  end
end

class ConjunctiveProposition < Proposition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].is_a?(Array)
      @args = args[0]
    else
      @args = args
    end
  end

  def latex
    "(#{args.map{|arg| arg.latex}.join(" \\wedge ")})"
  end
end

class DisjunctiveProposition < Proposition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].is_a?(Array)
      @args = args[0]
    else
      @args = args
    end
  end

  def latex
    "(#{args.map{|arg| arg.latex}.join(" \\vee ")})"
  end
end

class ComplementProposition < Proposition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].is_a?(Array)
      @args = args[0]
    else
      @args = args
    end
  end

  def latex
    "(\\neg #{args[0].latex})"
  end
end

class ImplicativeProposition < Proposition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].is_a?(Array)
      @args = args[0]
    else
      @args = args
    end
  end

  def latex
    "(#{args[0].latex} \\Rightarrow #{args[1].latex})"
  end
end

class DeductionRule
  attr_accessor :args

  def initialize(hypotheses,conclusions)

  end

end

def prop(name)
  AtomicProposition.new(name)
end

def andprop(*args)
  ConjunctiveProposition.new(*args)
end

def orprop(*args)
  DisjunctiveProposition.new(*args)
end

def complement(*args)
  ComplementProposition.new(*args)
end
