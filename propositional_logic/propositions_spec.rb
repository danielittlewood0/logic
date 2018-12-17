require './propositions.rb'

describe Proposition do
  let(:q){atom('q')}
  let(:r){atom('r')}
  let(:a){atom('a')}
  let(:b){atom('b')}
  let(:c){atom('c')}

  it "pretty print" do 
    s = land(q,r)
    expect(q.print).to eq 'q'
    expect(q.name).to eq 'q'
    expect(s.print).to eq '(q \\wedge r)'
  end

  describe '#substitute' do
    it 'replaces props == by .to_s' do 
      s = PropositionAnd.new([q,r])
      new_s = s.substitute(q,r)
      expect(new_s.print).to eq "(r \\wedge r)"
      
    end
  end

  describe '#expand_hypotheses' do
    it 'inserts b if the proof contains a and a \\rightarrow b' do
      old_proof = proof(a,a.implies(b))
      new_proof = old_proof.expand_hypotheses
      expect(new_proof).to eq proof(a,a.implies(b),b)
    end

    it 'inserts a if the proof contains not(not(a))' do
      old_proof = proof(neg(neg(a)))
      new_proof = old_proof.expand_hypotheses
      expect(new_proof).to eq proof(neg(neg(a)),a)
    end
  end

  describe '#obviously_entails, #entails' do
    it 'checks if hypotheses entail by modus ponens' do 
      a_b = a.implies(b)
      expect(proof(a,a_b).obviously_entails(b)).to eq nil
      expect(proof(a,a_b).expand_hypotheses.obviously_entails(b)).to eq true
    end

    it 'chains applications of modus ponens' do 
      a_b = a.implies(b)
      expect(proof(a,a_b).entails(b)).to eq true
    end

    it 'deduction theorem' do 
      a_b = a.implies(b)
      b_c = b.implies(c)
      a_c = a.implies(c)
      expect(proof(a_b,b_c).entails(a_c)).to eq true
    end

    it 'deduction theorem 2' do 
      a_b = a.implies(b)
      expect(proof(b).entails(a_b)).to eq true
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
