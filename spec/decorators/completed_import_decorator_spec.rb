# frozen_string_literal: true

RSpec.describe CompletedImportDecorator do
  let(:import) { create(:import) }

  let(:import_decorator) { described_class.decorate(import) }

  describe '#completed_at' do
    it 'returns time in relevant duration' do
      Timecop.freeze do
        import.update_attribute(:completed_at, 2.hours.ago)

        expect(import_decorator.completed_at).to eq('about 2 hours ago')
      end
    end
  end

  describe '#duration' do
    it 'returns duration in human readable way' do
      Timecop.freeze do
        import.update_attribute(:completed_at, 2.hours.ago)
        import.update_attribute(:started_at, 3.hours.ago)

        expect(import_decorator.duration).to eq('about 1 hour')
      end
    end
  end
end
