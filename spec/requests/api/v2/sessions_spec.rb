require 'rails_helper'

RSpec.describe 'Sesssions API', type: :request do 
	before { host! 'api.taskmanager.test' }

	let(:user) { create(:user) }

	let(:headers) do
		{
			'Accept' 	   => 'application/vnd.taskmanager.v2',
			'Content-Type' => Mime[:json].to_s
		} 
	end

	describe 'POST /sessions' do 
		before do
			post '/sessions', params: { session: credentials }.to_json, headers: headers 
		end 

		context 'when the credentials are incorrect' do 
			let(:credentials) { { email: user.email, password: 'invalid_password' } }

			it 'returns status code 401' do
				expect(response).to have_http_status(401)
			end

			it 'returns the json data for the erros' do
				expect(json_body).to have_key(:errors)
			end			

		end 
	end

	describe 'DELETE /sessions/:id' do 
		let(:auth_token) { user.auth_token }

		before do 
			delete "/sessions/#{auth_token}", params: {}, headers: headers
		end

		it 'returns status code 204' do 
			expect(response).to have_http_status(204)
		end

		it 'changes the user auth token' do 
			expect( User.find_by(auth_token: auth_token) ).to be_nil
		end 

	end

end