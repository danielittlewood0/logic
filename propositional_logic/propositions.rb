class Proposition 
  attr_accessor :args
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
    PropositionImplies.new([self,arg])
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

  def pre
    args[0]
  end

  def post
    args[1]
  end
end

class Proof
  attr_accessor :hypotheses
  alias_method :hyps, :hypotheses
 
  def initialize(hyps)
    @hypotheses = hyps
  end

  def ==(proof_2)
    self.hyps == proof_2.hyps
  end

  def expand_hypotheses
    hyps = hypotheses
    hyps.each do |prop|
      if (prop.class == PropositionImplies) && hyps.include?(prop.pre) && !hyps.include?(prop.post)
        hyps << prop.post unless hyps.include?(prop.post)
      end
      if (prop.is_a?(PropositionNot)) && (prop.args[0].is_a?(PropositionNot))
        hyps << prop.args[0].args[0]
      end
    end


    proof(*hyps)
  end

  def try_assumptions(conc,steps)
    old_hyps = hyps
    old_hyps.each do |prop| 
      if prop.is_a?(PropositionImplies) && !old_hyps.include?(prop.pre)
        if proof(*(old_hyps + [prop.pre])).entails(conc)
          self.hypotheses << conc
          steps << proof(*(old_hyps + [prop.pre])).entails(conc)
        end
      end
    end
  end

  def obviously_entails(conclusion)
    if hypotheses.include? conclusion 
      return true
    end
  end

  def entails(conclusion,steps=[])
    p "*****"
    if obviously_entails(conclusion)
      return true
      return steps
    else
      old_hyps = hypotheses
      expanded = expand_hypotheses
      p hyps.map(&:print)
      try_assumptions(conclusion,steps)
      p hyps.map(&:print)
      return nil if hyps == old_hyps
      steps << expanded 
      entails(conclusion,steps)
    end
  end

  def print 
    hypotheses.map(&:print).join(', ')
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

def proof(*hyps)
  Proof.new(hyps)
end

class ProofState
  attr_accessor :hypotheses, :goals

  
  


end
