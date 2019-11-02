RSpec.describe Import, type: :model do
  describe 'validations' do
  end

  describe '.created' do
    it 'return only imports in created state' do
      import1 = create(:import)
      import2 = create(:import, status: :completed)
      import3 = create(:import)

      expect(described_class.created).to match_array([import1, import3])
    end
  end

  describe '.started' do
    it 'returns imports only in pending and started states ordered by started_at' do
      import1 = create(:import, status: :completed)
      import2 = create(:import, status: :pending)
      import3 = create(:import, status: :started, started_at: 1.year.ago)
      import4 = create(:import, status: :started, started_at: 1.month.ago)

      expect(described_class.started.to_a).to eq([import2, import4, import3])
    end
  end

  describe '.completed' do
    it 'returns imports only in completed state ordered by completed_at' do
      import1 = create(:import, status: :started)
      import2 = create(:import, status: :completed, completed_at: 1.year.ago)
      import3 = create(:import, status: :completed, completed_at: 1.month.ago)

      expect(described_class.completed.to_a).to eq([import3, import2])
    end
  end
end
