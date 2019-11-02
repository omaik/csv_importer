
RSpec.describe ImportStatus do
  let(:import) do
    build(:import).tap do |import|
      import.file.attach(io: StringIO.new, filename: 'nothing.csv')
      import.save
    end
  end

  let(:import_status) { described_class.new(import) }

  describe '#start' do
    it 'moves import to the started status' do
      import_status.start

      expect(import.reload).to be_started
    end
  end

  describe '#finish' do
    it 'updates processed and errors_count' do
      import_status.build_import_stats

      3.times { import_status.increment }

      2.times { import_status.increment_errors }

      import_status.finish

      import.reload
      expect(import.processed).to eq(3)
      expect(import.errors_count).to eq(2)
    end

    it 'updates import status to completed' do
      import_status.build_import_stats
      import_status.finish

      expect(import.reload).to be_completed
    end
  end

  describe '#set_total' do
    it 'sets total_count attribute for import' do
      import_status.set_total(50)

      expect(import.reload.total_count).to eq(50)
    end
  end

  describe '#increment' do
    it 'increments import_stats processed count' do
      import_stats = ImportStatus::ImportStats.new(import)

      import_status.build_import_stats

      expect { import_status.increment }.to change { import_stats.get_processed }.by(1)
    end
  end

  describe '#increment_errors' do
    it 'increments import_stats count' do
      import_stats = ImportStatus::ImportStats.new(import)

      import_status.build_import_stats

      expect { import_status.increment_errors }.to change { import_stats.get_errors_count }.by(1)
    end
  end


  describe '.build' do
    it 'builds ImportStats' do
      expect(ImportStatus::ImportStats).to receive(:new)

      described_class.build(import)
    end
  end

  describe '.find' do
    it 'doesnt build ImportStats' do
      expect(ImportStatus::ImportStats).to_not receive(:new)

      described_class.find(import)
    end
  end
end
