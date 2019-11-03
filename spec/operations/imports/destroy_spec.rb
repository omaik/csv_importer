RSpec.describe Imports::Destroy do
  let(:import) { create(:import) }
  describe '#call' do

    it 'destroys import' do
      described_class.new(import).call

      expect(Import.exists?(id: import.id)).to eq(false)
    end

    it 'returns successful result' do
      result = described_class.new(import).call

      expect(result[:success]).to eq(true)
    end
  end
end
