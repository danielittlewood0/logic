class Proposition
  def implies(b)
    new_prop = Implication.new
    new_prop.premise = self
    new_prop.conclusion = b
    return new_prop
  end
end

class VariableProposition < Proposition

end

class Implication < Proposition
  attr_accessor :premise, :conclusion
  def ==(obj)
    (self.premise == obj.premise) &&
    (self.conclusion == obj.conclusion)
  end
end

class Conjunction
  attr_accessor :conjuncts
end

def conj(*conjuncts)
  new_prop = Conjunction.new
  new_prop.conjuncts = conjuncts
  return new_prop
end

class Disjunction
  attr_accessor :disjuncts
end

class Proof
  attr_accessor :steps
end

class DeductionRule
  attr_accessor :hypotheses, :conclusion
  def ==(obj)
    (self.hypotheses == obj.hypotheses) &&
    (self.conclusion == obj.conclusion)
  end
end

class PropList
  attr_accessor :propositions
  def fits(rule)
    self == rule.hyps
  end
end

def rule(hyps,conc)
  rule = DeductionRule.new
  rule.hypotheses = hyps
  rule.conclusion = conc
  return rule
end

p_1 = VariableProposition.new
p_2 = VariableProposition.new

def modus_ponens(a,b)
  hyps = [a,a.implies(b)]
  conc = b
  return rule(hyps,conc)
end


# modus_ponens = rule([p_1,p_1.implies(p_2)],p_2)
# and_intro = rule([p_1,p_2],conj(p_1,p_2))
#
# $rules = [modus_ponens,and_intro]
