RSpec.describe StartedImportDecorator do
  let(:import) { create(:import) }
  let(:import_status) { ImportStatus.new(import) }

  let(:import_decorator) { described_class.decorate(import) }

  describe '#progress' do
    context 'when import hasnt started' do
      it 'returns pending' do
        import.pending!

        expect(import_decorator.progress).to eq('pending')
      end
    end

    context 'when import started but total_count is not set' do
      it 'returns Calculating' do
        import.started!

        expect(import_decorator.progress).to eq('Calculating')
      end
    end

    context 'when total count is set' do
      it 'calculates based on processed and errors' do
        import.started!
        import_status.total(10)
        2.times { import_status.increment }
        3.times { import_status.increment_errors }

        expect(import_decorator.progress).to eq('50.0 %')
      end
    end
  end

  describe '#errors' do
    it 'takes errors from import_status' do
      3.times { import_status.increment_errors }

      expect(import_decorator.errors).to eq(3)
    end
  end

  describe '#started_at' do
    context 'pending job' do
      it 'returns nil' do
        import.pending!

        expect(import_decorator.started_at).to eq(nil)
      end
    end

    context 'import started' do
      it 'returns human readable started_at' do
        Timecop.freeze do
          import.update(status: :started, started_at: 3.hours.ago)

          expect(import_decorator.started_at).to eq("about 3 hours ago")
        end
      end
    end
  end
end
