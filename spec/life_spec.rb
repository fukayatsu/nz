RSpec.describe Life do
  describe '.create_origin' do
    it 'copy default gene to map' do
      map = [-1, -1, -1, -1, -1, -1]
      expect(Life).to receive(:default_gene) { [:nop1, :nop1, :nop0] }
      described_class.create_origin(map, at: 2)
      expect(map).to eq [-1, -1, 1, 1, 0, -1]
    end
  end
end
