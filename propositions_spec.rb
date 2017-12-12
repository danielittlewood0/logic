require "./propositions.rb"

describe Proposition do
  it '' do
    a = Proposition.new
    b = Proposition.new
    implication = a.implies(b)
    expect(implication.class).to eq Implication
  end
end

describe DeductionRule do
  it '' do
    p_1 = Proposition.new
    p_2 = Proposition.new
    hyps = [p_1,p_1.implies(p_2)]
    modus_ponens = rule(hyps,p_2)
    expect(modus_ponens.class).to eq DeductionRule
  end
end
