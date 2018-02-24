RSpec.describe Soup do
  let(:soup) { described_class.new }

  describe '#lives_count' do
    it do
      expect(soup.lives_count).to eq(1)
    end
  end

  describe '#tick' do
    it do
      expect(soup.lives_count).to eq(1)
      soup.tick(100)
      expect(soup.lives_count).to eq(2)
    end
  end
end
