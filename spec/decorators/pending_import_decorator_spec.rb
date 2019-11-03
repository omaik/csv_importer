# frozen_string_literal: true

RSpec.describe PendingImportDecorator do
  let(:import) { create(:import, status: :pending) }

  let(:import_decorator) { described_class.decorate(import) }
  describe '#errors' do
    it 'returns nil' do
      expect(import_decorator.errors).to be_nil
    end
  end

  describe '#progress' do
    it 'returns pending' do
      expect(import_decorator.progress).to eq('pending')
    end
  end
end
