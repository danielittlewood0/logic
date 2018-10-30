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
end
