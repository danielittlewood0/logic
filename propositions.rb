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

  def try_to_match(fixed,substitutions)
    variable = self
    if variable.atomic?
      if substitutions.keys.include?(variable)
        if substitutions[variable] == fixed
          return
        else
          return false
        end
      else
        substitutions[variable] = fixed
      end
    else
      if (variable.class != fixed.class) || (variable.args.length != fixed.args.length)
        return false
      else
        for i in 0...variables.args.length
          variable.args[i].try_to_match(fixed,substitutions)
        end
      end
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
end

class Conjunction < Proposition
  attr_accessor :conjuncts

  def atomic?
    false
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
    forced_subs = {}
    rule.conclusion.try_to_match(conclusion,forced_subs)
    # return forced_subs
    # if forced_subs == false
    #   return false
    # end
    unmatched_hyps = rule.hypotheses.dup
    matched_hyps = []
    substitutions = [forced_subs.dup]
    used_steps = []
    unused_steps = self.steps.dup
    while true do
      if (unused_steps == []) && (matched_hyps == [])
        return false
      end
      if (unused_steps == []) && (matched_hyps != [])
        #backup
        next
      end
      if (unmatched_hyps == [])
        return substitutions.last
      end
      #go down a layer
      #need a new steps list for each hypothesis!
      # next_hypothesis = unmatched_hyps.pop
      # next_step = unused_steps.pop
      # matched_hyps <<
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
