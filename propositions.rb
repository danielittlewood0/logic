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
          variable.args[i].try_to_match(fixed.args[i],substitutions)
        end
      end
    end
    if variable.substitute(substitutions) == fixed
      return substitutions
    else
      return false
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

  def name
    "#{premise.name} => #{conclusion.name}"
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
    forced_subs = {}
    rule.conclusion.try_to_match(conclusion,forced_subs)

    unmatched_hyps = rule.hypotheses.dup
    matched_hyps = []
    substitutions = [forced_subs.dup]
    steps_history = []
    unused_steps = []
    unused_steps = self.steps.dup
    used_steps = []

    matched_hyps << unmatched_hyps.pop

    loop do
      p substitutions.map{|subs| subs.map{|k,v| "#{k.name} maps to #{v.name}"}}
      p "unmatched hyps: #{unmatched_hyps.map{|hyp| hyp.name}}"
      p "matched hyps: #{matched_hyps.map{|hyp| hyp.name}}"
      p "unused steps: #{unused_steps.map{|prop| prop.name}}"
      p "used steps: #{used_steps.map{|prop| prop.name}}"
      p "steps history: #{steps_history.map{|steps| steps.map{|prop| prop.name}}}"
      if (matched_hyps == []) && (unused_steps == [])
        return false
      elsif (unused_steps != [])
        puts "tried to match #{matched_hyps[-1].name} to #{unused_steps[-1].name}"
        # match = _try_next_step(matched_hyps,unused_steps,used_steps,substitutions)
        next_step = unused_steps.pop
        subs_to_update = substitutions.last.dup
        match = matched_hyps.last.try_to_match(next_step,subs_to_update)
        if match
          used_steps << next_step
          substitutions << subs_to_update
        end
      elsif (matched_hyps != []) && (unused_steps == [])
        puts 'backed up'
        # _back_up(unmatched_hyps,matched_hyps,used_steps,unused_steps,steps_history,substitutions)
        unmatched_hyps << matched_hyps.pop
        used_steps.pop
        unused_steps = steps_history.pop
        substitutions.pop
        p "unused steps: #{unused_steps.map{|prop| prop.name}}"

        match = false
      end
      if (match != false) && (unmatched_hyps != [])
        puts "match succeeded: subs are now #{substitutions.last.map{|k,v| "#{k.name} maps to #{v.name}"}}"
        # _try_next_hyp(unmatched_hyps,matched_hyps,used_steps,unused_steps,steps_history)
        matched_hyps << unmatched_hyps.pop
        steps_history << unused_steps.dup
        unused_steps = self.steps.dup.select{|step| !used_steps.include?(step)}
      elsif match && (unmatched_hyps == [])
        'win!!'
        return substitutions.last
      else
        p 'match failed'
      end
      p "********************"
    end
  end

  def _try_next_step(matched_hyps,unused_steps,used_steps,substitutions)
    next_step = unused_steps.pop
    subs_to_update = substitutions.last.dup
    match = matched_hyps.last.try_to_match(next_step,subs_to_update)
    if match
      used_steps << next_step
      substitutions << subs_to_update
    end
    return match
  end

  def _back_up(unmatched_hyps,matched_hyps,used_steps,unused_steps,steps_history,substitutions)
    unmatched_hyps << matched_hyps.pop
    used_steps.pop
    # unused_steps = steps_history.pop
    substitutions.pop
  end

  def _try_next_hyp(unmatched_hyps,matched_hyps,used_steps,unused_steps,steps_history)
    matched_hyps << unmatched_hyps.pop
    steps_history << unused_steps.dup
    unused_steps = self.steps.dup.select{|step| !used_steps.include?(step)}
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
