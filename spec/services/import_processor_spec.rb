# frozen_string_literal: true

RSpec.describe ImportProcessor do
  let(:file) { 'spec/fixtures/files/customers.csv' }

  let(:import) do
    build(:import).tap do |import|
      import.file.attach(io: File.open(file), filename: 'customers.csv')
      import.save
    end
  end

  let(:import_processor) do
    described_class.new(import)
  end

  it 'imports the customer' do
    expect do
      import_processor.call
    end.to change { Customer.count }.by(1)
  end

  it 'moves import to completed state' do
    import_processor.call

    expect(import.reload).to be_completed
  end

  it 'sets the total count and processed for the import' do
    import_processor.call

    import.reload
    expect(import.total_count).to eq(1)
    expect(import.processed).to eq(1)
  end

  context 'with invalid data' do
    let(:file) { 'spec/fixtures/files/customers_with_one_invalid.csv' }

    it 'creates only a valid customer' do
      expect do
        import_processor.call
      end.to change { Customer.count }.by(1)
    end

    it 'increments processed and errors_count correctly' do
      import_processor.call

      import.reload
      expect(import.total_count).to eq(2)
      expect(import.processed).to eq(1)
      expect(import.errors_count).to eq(1)
    end
  end

  context 'with invalid csv headers' do
    let(:file) { 'spec/fixtures/files/invalid_csv.csv' }

    it 'breaks the processing' do
      import_processor.call

      import.reload
      expect(import.processed).to eq(0)
      expect(import.errors_count).to eq(1)
    end
  end
end
