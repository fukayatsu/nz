RSpec.describe Soup do
  let(:soup) { described_class.new }

  describe '#lives_summary' do
    it do
      soup.tick(1000)
      expect(soup.lives_summary).to eq "76-e15c9785ee64d8977f2fb2aa8f904345: 2"
    end
  end

  describe '#tick' do
    it do
      expect(soup.lives_count).to eq 1
      soup.tick(1000)
      expect(soup.lives_count).to eq 2
    end
  end
end
