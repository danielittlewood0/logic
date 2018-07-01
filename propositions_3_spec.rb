require './propositions_3.rb'

describe AtomicProposition do
	it 'initialises' do 
		a = atom('a')
		b = atom('b')
		a_dash = atom('a')
		expect(a == b).to eq false 
		expect(a == a_dash).to eq true
	end
end

describe ImpliesProposition do
	it 'initialises' do
		a = atom('a')
		b = atom('b')
		a_dash = atom('a')

		p_1 = a.implies(b)
		p_2 = a.implies(a_dash)
		p_3 = a_dash.implies(a) 
		expect(p_1 == p_2).to eq false
		expect(p_3 == p_2).to eq true
	end
end

describe Proposition do
	it '#holds?' do
		a = atom('a')
		b = atom('b')

		expect(a.holds?([a])).to eq true
		expect(b.holds?([a])).to eq nil
	end
	it '#holds?' do
		a = atom('a')
		b = atom('b')
		p_1 = a.implies(b)
		expect(b.holds?([a,p_1])).to eq true
	end
end

