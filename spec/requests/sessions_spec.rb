require 'swagger_helper'

RSpec.describe 'Sessions API', type: :request do
  path '/users/sign_in' do
    post 'Creates a session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response '201', 'session established' do
        let(:user) { FactoryBot.create(:user) }
        let(:request_body) do
          {
            email: user.email,
            password: user.password
          }
        end

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:request_body) do
          {
            email: 'invalid@example.com',
            password: 'wrongpassword'
          }
        end

        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete 'Ends a session' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'

      let(:user) { FactoryBot.create(:user) }

      before do
        post '/users/sign_in', params: { email: user.email, password: user.password }
      end

      response '200', 'session ended' do
        let(:headers) do
          { 'Authorization' => "Bearer #{response.headers['Authorization']}" }
        end

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:headers) do
          { 'Authorization' => "Bearer invalid_token" }
        end

        run_test!
      end
    end
  end
end
