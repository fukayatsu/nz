RSpec.describe Island do
  let(:island) { described_class.new }

  describe '#tick' do
    it 'return step count' do
      expect(island.tick).to eq 1
    end
  end
end
