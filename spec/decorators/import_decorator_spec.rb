# frozen_string_literal: true

RSpec.describe ImportDecorator do
  let(:import) { create(:import) }

  let(:import_decorator) { described_class.decorate(import) }
  describe '#started_at' do
    context 'started_at blank' do
      it 'returns nil' do
        expect(import_decorator.started_at).to eq(nil)
      end
    end

    context 'import started' do
      it 'returns human readable started_at' do
        Timecop.freeze do
          import.update(started_at: 3.hours.ago)

          expect(import_decorator.started_at).to eq('about 3 hours ago')
        end
      end
    end
  end

  describe '#created_at' do
    it 'returns human readable created_at' do
      import_decorator

      Timecop.travel(Time.zone.now + 3.hours) do
        expect(import_decorator.created_at).to eq('about 3 hours ago')
      end
    end
  end

  describe '#filename' do
    it 'returns filename of the attached file' do
      expect(import_decorator.filename).to eq(
        import.file.attachment.blob.filename.to_s
      )
    end
  end
end
