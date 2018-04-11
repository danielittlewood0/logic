require "./propositions_2.rb"

describe '#initialize' do
  it 'initializes events' do
    exp = prop('p')
    expect(exp.class).to eq AtomicProposition
    expect(exp.name).to eq 'p'
    expect(exp.latex).to eq 'p'
  end

  it 'initializes conjunctions' do
    evs = ['p','q','r'].map{|l| prop(l)}
    exp = andprop(evs)
    expect(exp.class).to eq ConjunctiveProposition
    expect(exp.args).to eq evs
  end
end

describe '#latex' do
  it 'latexes atomic events' do
    exp = prop('p')
    expect(exp.name).to eq 'p'
    expect(exp.latex).to eq 'p'
  end

  it 'latexes conjunctions' do
    evs = ['p','q','r'].map{|l| prop(l)}
    exp = andprop(evs)
    expect(exp.latex).to eq "(p \\wedge q \\wedge r)"
  end

  it 'latexes disjunctions' do
    evs = ['p','q','r'].map{|l| prop(l)}
    exp = orprop(evs)
    expect(exp.latex).to eq "(p \\vee q \\vee r)"
  end
end

describe '#substitute' do
  it 'replaces all instances of the given prop with its target' do
    a = prop('a')
    b = prop('b')
    expect(a.substitute(a,b)).to eq b
  end

  it 'eg2' do
    evs = ['p','q','r'].map{|l| prop(l)}
    exp = orprop(evs)
    exp.substitute(prop('p'),prop('b'))
    expect(exp.latex).to eq "(b \\vee q \\vee r)"
  end

  it '#multisub' do
    evs_1 = ['p','q','r'].map{|l| prop(l)}
    evs_2 = ['a','b','c'].map{|l| prop(l)}
    sub_hash = {}
    for i in 0..2
      sub_hash[evs_1[i]] = evs_2[i]
    end
    exp = andprop(evs_1).multisub(sub_hash)
    expect(exp.latex).to eq "(a \\wedge b \\wedge c)"
  end
end
