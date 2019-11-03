# frozen_string_literal: true

RSpec.describe StartedImportDecorator do
  let(:import) { create(:import) }
  let(:import_status) { ImportStatus.new(import) }

  let(:import_decorator) { described_class.decorate(import) }

  describe '#progress' do
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
end
