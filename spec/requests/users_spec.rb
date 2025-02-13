require 'rails_helper'

RSpec.describe "Users API", type: :request do
  # Create a user using FactoryBot
  let!(:user) { create(:user) }  # Create, not build
  let(:user_id) { user.id }
  let(:valid_attributes) { { user: { active: true } } }

  describe "PATCH /users/:id" do
    context 'when the record exists' do
      before { patch "/users/#{user_id}", params: valid_attributes }

      it 'returns the updated user' do
        expect(response.body).to include('active')
        expect(response.body).to include('true')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:invalid_user_id) { 1000 }

      before { patch "/users/#{invalid_user_id}", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to include("Couldn't find User")
      end
    end
  end
end
