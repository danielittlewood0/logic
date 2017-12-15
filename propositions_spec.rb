require "./propositions.rb"

describe Proposition do
  it '' do
    a = Proposition.new
    b = Proposition.new
    implication = a.implies(b)
    expect(implication.class).to eq Implication
  end
end

describe Conjunction do
  it 'initialises' do
    a = Proposition.new
    b = Proposition.new
    prop = conj(a,b)
    expect(prop.class).to eq Conjunction
    expect(prop.conjuncts).to eq [a,b]
    expect(prop.free_vars).to eq [a,b]
  end
end

describe DeductionRule do
  it '' do
    p_1 = VariableProposition.new
    p_2 = VariableProposition.new
    hyps = [p_1,p_1.implies(p_2)]
    modus_ponens = rule(hyps,p_2)
    expect(modus_ponens.class).to eq DeductionRule
  end
end

describe PropList do
  describe '#' do
    it '' do
      p_1 = VariableProposition.new
      p_2 = VariableProposition.new
      hyps = [p_1,p_1.implies(p_2)]
      modus_ponens = rule(hyps,p_2)
      sym = :modus_ponens
      new_mp = send(sym,p_1,p_2)
      expect(new_mp).to eq modus_ponens
    end
  end

  describe 'check logic' do
    p_1 = VariableProposition.new
    p_2 = VariableProposition.new
    a = Proposition.new
    b = Proposition.new

    it 'can make substitutions' do
      old_implication = p_1.implies(p_2)
      new_implication = a.implies(b)
      hash = {p_1 => a, p_2 => b}
      expect(hash[p_1]).to eq a
      expect(hash[p_2]).to eq b
      expect(old_implication.substitute(hash)).to eq new_implication
    end

    modus_ponens = rule([p_1.implies(p_2),p_1],p_2)
    rules = [modus_ponens]

    it 'can deduce by modus_ponens' do
      easy_proof = Proof.new
      easy_proof.steps = [p_1,p_1.implies(p_2)]
      p easy_proof.entails?(modus_ponens,p_2)
    end
  end
end
