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
