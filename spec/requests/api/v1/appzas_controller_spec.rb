require 'rails_helper'

RSpec.describe Api::V1::AppzasController, type: :request do
  let(:appza) { create(:appza) }
  let(:api_v_headers) { api_valid_headers_without_authorization }

  describe "GET /authza/:id" do
    context "when valid request" do
      before do
        get api_appza_path(appza.id), params: { }, headers: api_v_headers
      end

      it 'returns success message' do
        expect(json['message']).to eq Message.appza_show_loaded(appza.id)
      end

      it 'returns appza data of particular ID' do
        expect(json['data']['name']).to eq appza.name
        expect(json['data']['url']).to eq appza.url
        expect(json['data']['requires']).to eq appza.requires
      end

      it_behaves_like 'returns 200 success status'
    end
  end
end
