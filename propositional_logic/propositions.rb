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
    hyps = hypotheses.dup
    hyps.each do |prop|
      if (prop.class == PropositionImplies) && hyps.include?(prop.pre) && !hyps.include?(prop.post)
        puts "I deduced #{prop.post.print}"unless hyps.include?(prop.post)
        hyps << prop.post unless hyps.include?(prop.post)
      end
      if (prop.is_a?(PropositionNot)) && (prop.args[0].is_a?(PropositionNot))
        hyps << prop.args[0].args[0]
      end
    end


    proof(*hyps)
  end

  def try_assumptions!(conc,steps)
    old_hyps = hyps
    old_hyps.each do |prop| 
      if conc.is_a?(PropositionImplies) && !old_hyps.include?(conc.pre)&& !old_hyps.include?(conc)
        puts "I tried assuming #{conc.pre.print}"
        puts ">>"
        if proof(*(old_hyps + [conc.pre])).entails(conc.post)
          puts "<<"
          puts "So I deduced #{conc.print}"
          self.hypotheses << conc
          steps << proof(*(old_hyps + [conc.pre])).entails(conc)
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
    if obviously_entails(conclusion)
      return true
    else
      old_hyps = hypotheses
      expanded = expand_hypotheses
      if expanded.obviously_entails(conclusion)
        return true
      end
      expanded.try_assumptions!(conclusion,steps)
      if expanded.obviously_entails(conclusion)
        return true
      end
      if expanded == proof(*old_hyps)
        return nil
      end
      steps << expanded 
      return expanded.entails(conclusion,steps)
    end
  end

  def print 
    hypotheses.map(&:print).join(', ')
  end
end

def and(*args)
  PropositionAnd.new(args)
end

def land(*args)
  PropositionAnd.new(args)
end

def or(*args)
  PropositionOr.new(args)
end

def lor(*args)
  PropositionOr.new(args)
end

def not(*args)
  PropositionNot.new(args)
end

def neg(*args)
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
