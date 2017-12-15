class Proposition
  def implies(b)
    new_prop = Implication.new
    new_prop.premise = self
    new_prop.conclusion = b
    return new_prop
  end

  def args
    if is_a?(Implication)
      [premise,conclusion]
    elsif is_a?(Conjunction)
      conjuncts
    elsif is_a?(Disjunction)
      disjuncts
    else
      []
    end
  end

  def args=(args)
    if is_a?(Implication)
      self.premise,self.conclusion = args
    elsif is_a?(Conjunction)
      self.conjuncts = args
    elsif is_a?(Disjunction)
      self.disjuncts = args
    else
      []
    end
  end

  def atomic?
    true
  end

  def free_vars
    unless atomic?
      args.inject([]){|list,arg| list + arg.free_vars}
    else
      [self]
    end
  end

  def try_to_match(prop)
    return {self => prop}
  end

  def substitute(hash)
    if atomic?
      if hash[self].nil?
        return self
      else
        return hash[self]
      end
    else
      new_args = []
      args.each do |arg|
        if arg.atomic?
          new_args << hash[arg]
        else
          new_args << arg.substitute(hash)
        end
      end
      new_prop = self.class.new
      new_prop.args = new_args
      return new_prop
    end
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

  def atomic?
    false
  end

  def try_to_match(prop)
    unless prop.is_a?(Implication)
      return false
    end
    h = {self.premise => prop.premise, self.conclusion => prop.conclusion}
    return h
  end
end

class Conjunction < Proposition
  attr_accessor :conjuncts

  def atomic?
    false
  end

  def try_to_match(prop)
    unless prop.is_a?(Conjunction)
      return false
    end
    h = Hash.new
    for i in 0...self.conjuncts.length
      if self.conjuncts[i].atomic?
        h[self.conjuncts[i]] = prop.conjuncts[i]
      else
        return false
      end
    end
    return h
  end
end

def conj(*conjuncts)
  new_prop = Conjunction.new
  new_prop.conjuncts = conjuncts
  return new_prop
end

class Disjunction < Proposition
  attr_accessor :disjuncts

  def atomic?
    false
  end

  def try_to_match(prop)
    unless prop.is_a?(Disjunction)
      return false
    end
    h = hash.new
    for i in 0...self.disjuncts.length
      if self.disjuncts[i].atomic?
        h[self.disjuncts[i]] = prop.disjuncts[i]
      else
        return false
      end
    end
    return h
  end
end

class Proof
  attr_accessor :steps

  def trivially_entails?(rule,conclusion)
    rule.hypotheses.each{|hyp| self.steps.include?(hyp)} &&
    (rule.conclusion == conclusion)
  end

  def entails?(rule,conclusion)
    rule_vars = rule.free_vars
    proof_vars = self.steps.map{|step| step.free_vars}.flatten.uniq
    forced_subs = rule.conclusion.try_to_match(conclusion)
    if forced_subs.nil?
      return false
    end
    remaining_vars = proof_vars - forced_subs.keys
    rule.hypotheses.each do |hyp|
      self.steps.each do |step|
        maybe_hash = hyp.try_to_match(step)
        raise 'this is complicated'
      end
    end

  end
end

class DeductionRule
  attr_accessor :hypotheses, :conclusion
  def ==(obj)
    (self.hypotheses == obj.hypotheses) &&
    (self.conclusion == obj.conclusion)
  end

  def free_vars
    (self.hypotheses + [self.conclusion]).map{|prop| prop.free_vars}.flatten.uniq
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
