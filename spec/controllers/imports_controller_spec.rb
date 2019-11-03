# frozen_string_literal: true

RSpec.describe ImportsController, type: :controller do
  describe '#create' do
    let(:params) do
      {
        import: {
          title: 'Title',
          file: fixture_file_upload('files/customers.csv', 'text/csv')
        }
      }
    end
    it 'creates the import' do
      expect do
        post :create, params: params
      end.to change { Import.count }.by(1)
    end

    it 'redirects to the imports page' do
      post :create, params: params

      expect(response).to redirect_to imports_url
    end

    context 'validation fails' do
      it 'doesnt redirect to import page' do
        params[:import].delete(:file)

        post :create, params: params

        expect(response).to render_template(:new)
      end
    end
  end

  describe '#start' do
    let(:import) { create(:import) }

    it 'starts the import' do
      post :start, params: { id: import.id }

      expect(import.reload).to be_pending
    end

    it 'enqueues import job' do
      post :start, params: { id: import.id }

      expect(ImportJob).to have_enqueued_sidekiq_job(import.id)
    end

    it 'redirects to the imports page' do
      post :start, params: { id: import.id }

      expect(response).to redirect_to imports_url
    end

    context 'import doesnt exist' do
      it 'returns 404' do
        post :start, params: { id: 12_435 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#edit' do
    let(:import) { create(:import) }

    it 'renders edit' do
      get :edit, params: { id: import.id }

      expect(response).to render_template(:edit)
    end

    context 'import doesnt exist' do
      it 'returns 404' do
        get :edit, params: { id: 123_244 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#index' do
    it 'renders index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe '#update' do
    let(:import) { create(:import) }

    it 'updates its title' do
      put :update, params: { id: import.id, import: { title: 'New' } }

      expect(import.reload.title).to eq('New')
    end

    it 'redirects to index page' do
      put :update, params: { id: import.id, import: { title: 'New' } }

      expect(response).to redirect_to imports_url
    end

    context 'validations errors' do
      it 'renders edit' do
        put :update, params: { id: import.id, import: { title: '' } }

        expect(response).to render_template(:edit)
      end

      it 'doesnt update title' do
        put :update, params: { id: import.id, import: { title: '' } }

        expect(import.reload.title).to be_present
      end
    end

    context 'import doesnt exist' do
      it 'returns 404' do
        put :update, params: { id: 12_344_545, import: { title: 'New' } }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#destroy' do
    let(:import) { create(:import) }

    it 'destroys import' do
      delete :destroy, params: { id: import.id }

      expect(Import.exists?(id: import.id)).to eq(false)
    end

    it 'redirects to imports page' do
      delete :destroy, params: { id: import.id }

      expect(response).to redirect_to imports_url
    end

    context 'when import doesnt exist' do
      it 'returns 404' do
        delete :destroy, params: { id: 122_332_232 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
