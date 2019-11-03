RSpec.describe Imports::Start do
  let(:import) { create(:import) }

  let(:start_operation) { described_class.new(import) }

  describe '#call' do
    it 'moves import to pending state' do
      start_operation.call

      expect(import.reload).to be_pending
    end

    it 'schedules background job for import' do
      start_operation.call

      expect(ImportJob).to have_enqueued_sidekiq_job(import.id)
    end

    it 'returns successful result' do
      result = start_operation.call

      expect(result[:success]).to eq(true)
    end

    context 'with exception during job scheduling' do
      it 'returns error result' do
        allow(ImportJob).to receive(:perform_async).and_raise(RuntimeError)

        result = start_operation.call

        expect(result[:success]).to eq(false)
      end
    end
  end
end
