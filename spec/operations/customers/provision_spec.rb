RSpec.describe Customers::Provision do
  describe '#call' do
    let(:import) { create(:import) }

    let(:params) { { date_of_birth: '04/01/1996', first_name: 'Test', last_name: 'Test', email: 'test@test.com', import_id: import.id } }

    it 'it returns successful result' do
      result = described_class.new(params).call

      expect(result[:success]).to eq(true)
    end

    it 'provisions the customer' do
      described_class.new(params).call

      expect(Customer.exists?(email: params[:email])).to eq(true)
    end

    context 'invalid params' do
      let(:params) { { date_of_birth: '04/01/2018', first_name: 'Test', last_name: 'Test', email: 'test@test.com', import_id: import.id} }

      it 'returns unsuccessful result' do
        Timecop.travel(Time.new(2019, 01, 01)) do
          result = described_class.new(params).call

          expect(result).to include(success: false, errors: ["Date of birth must be bigger than 18 and smaller than 100 years"])
        end
      end

      it 'doesnt create a customer' do
        Timecop.travel(Time.new(2019, 01,01)) do
          described_class.new(params).call

          expect(Customer.exists?(email: params[:email])).to eq(false)
        end
      end
    end

    context 'with duplicated email in the same import' do
      it 'returns an error' do
        described_class.new(params).call

        result = described_class.new(params).call

        expect(result).to include(success: false, errors: ["Email has already been taken"])
      end

      it 'doesnt update the customer' do
        described_class.new(params).call

        result = described_class.new(params.merge(first_name: 'New')).call

        expect(Customer.find_by(email: params[:email]).first_name).to eq(params[:first_name])
      end
    end

    context 'different imports' do
      let(:import2) { create(:import) }
      let(:import2_params) { { date_of_birth: '04/01/1996', first_name: 'Test', last_name: 'New', email: 'test@test.com', import_id: import2.id } }

      it 'updates customer from the previous import' do
        customer = described_class.new(params).call[:object]

        described_class.new(import2_params).call

        expect(customer.reload.last_name).to eq(import2_params[:last_name])
      end
    end
  end
end
