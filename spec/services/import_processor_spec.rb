
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

  it 'imports the user' do
    import_processor.call
    binding.irb
  end
end
