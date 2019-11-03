# frozen_string_literal: true

RSpec.describe Imports::Update do
  let(:import) { create(:import, title: 'Old') }

  let(:params) { { title: 'New' } }

  let(:update_operation) { described_class.new(import, params) }

  describe '#call' do
    it 'updates the import' do
      update_operation.call

      expect(import.reload.title).to eq('New')
    end

    it 'returns successful result' do
      result = update_operation.call

      expect(result[:success]).to eq(true)
    end

    context 'params are invalid' do
      let(:params) { { title: '' } }

      it 'doesnt update the import' do
        update_operation.call

        expect(import.reload.title).to eq('Old')
      end

      it 'returns error result' do
        result = update_operation.call

        expect(result).to include(
          success: false, errors: ["Title can't be blank"]
        )
      end
    end
  end
end
