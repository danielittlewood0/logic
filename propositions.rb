class Proposition
  def implies(b)
    new_prop = Implication.new
    new_prop.premise = self
    new_prop.conclusion = b
    return new_prop
  end
end

class Implication < Proposition
  attr_accessor :premise, :conclusion
end

class Proof
  attr_accessor :steps
end

class DeductionRule
  attr_accessor :hypotheses, :conclusion
end

def rule(hyps,conc)
  rule = DeductionRule.new
  rule.hypotheses = hyps
  rule.conclusion = conc
  return rule
end
