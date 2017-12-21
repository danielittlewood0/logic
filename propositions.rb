class Proposition
  attr_accessor :name
  def ==(obj)
    (self.class == obj.class) && (self.name == obj.name)
  end

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
        for i in 0...variable.args.length
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
  # def ==(obj)
  #   (obj.is_a?(Implication)) &&
  #   (self.premise == obj.premise) &&
  #   (self.conclusion == obj.conclusion)
  # end

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

    unmatched_hyps = rule.hypotheses.dup
    matched_hyps = []
    substitutions = [forced_subs.dup]
    steps_history = []
    used_steps = []

    unused_steps = self.steps.dup
    next_hypothesis = unmatched_hyps.pop
    matched_hyps << next_hypothesis.dup
    # p matched_hyps.map{|obj| obj.name}
    while true do
      p unused_steps
      next_step = unused_steps.pop
      maybe_subs = substitutions.last.dup

      # p maybe_subs.map{|k,v| "#{k.name} maps to #{v.name}"}
      match = next_hypothesis.try_to_match(next_step,maybe_subs)
      if match == false
        p 'hello'
        p next_hypothesis.name
        p next_step.name
      elsif (unmatched_hyps == [])
        return substitutions.last
      else
        # new_subs = substitutions.last.dup.merge(maybe_subs)
        substitutions << maybe_subs
        next_hypothesis = unmatched_hyps.pop
        matched_hyps << next_hypothesis.dup
        steps_history << unused_steps.dup
        used_steps << next_step.dup
        unused_steps = self.steps.dup.select{|step| !used_steps.include?(step)}# - used_steps
      end
      # if (unmatched_hyps == [])
      #   return substitutions.last
      # end

      if (unused_steps == []) && (matched_hyps == [])
        return false
      elsif (unused_steps == []) && (matched_hyps != [])
        p 'hi'
        unmatched_hyps << next_hypothesis.dup
        next_hypothesis = matched_hyps.pop
        unused_steps = steps_history.pop
        substitutions.pop
        used_steps.pop
        next
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
