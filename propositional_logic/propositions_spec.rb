require './propositions.rb'

describe Proposition do
  it "test" do 
    q = PropositionAtomic.new('q')
    r = PropositionAtomic.new('r')
    s = PropositionAnd.new([q,r])
    expect(q.print).to eq 'q'
    expect(q.name).to eq 'q'
    expect(s.print).to eq '(q \\wedge r)'
  end

  describe '#substitute' do
    it 'replaces things by same string' do 
      q = PropositionAtomic.new('q')
      r = PropositionAtomic.new('r')
      s = PropositionAnd.new([q,r])
      new_s = s.substitute(q,r)
      expect(new_s.print).to eq "(r \\wedge r)"
      
    end
  end

  describe '#entails' do
    it 'checks if hypotheses entail by modus ponens' do 
      a = atom('a')
      b = atom('b')
      a_b = a.implies(b)
      expect(proof(a,a_b).obviously_entails(b)).to eq nil
      expect(proof(a,a_b).expand_hypotheses.obviously_entails(b)).to eq true
    end

    it 'checks if hypotheses entail by modus ponens' do 
      a = atom('a')
      b = atom('b')
      c = atom('c')
      a_b = a.implies(b)
      b_c = b.implies(c)
      a_c = a.implies(c)
      expect(proof(a_b,b_c).obviously_entails(a_c)).to eq true
    end
  end

  describe "Proof" do 
    describe "#==" do 
      it "two proofs are == when all their hyps are ==" do
        a = atom('a')
        b = atom('b')
        a_b = a.implies(b)
        expect(proof(a,a_b).expand_hypotheses == proof(a,a_b,b)).to eq true
      end
    end
  end
end
