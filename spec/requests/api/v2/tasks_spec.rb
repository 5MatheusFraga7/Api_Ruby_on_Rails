require 'rails_helper'

RSpec.describe 'Task API' do 

	before { host! 'api.taskmanager.test' }

	let!(:user) { create(:user) }
	let(:headers) do 
		{
			'Accept' 	    => 'application/vnd.taskmanager.v2',
			'Content-type'  =>  Mime[:json].to_s,
			'Authorization' =>  user.auth_token
		}
	end

	describe 'GET /tasks' do 

		before do 
			create_list(:task, 5, user_id: user.id)

			get '/tasks', params: {}, headers: headers
		end

		it 'status code is 200' do 
			expect(response).to have_http_status(200)
		end
		it 'returns 5 tasks from database' do 
			expect(json_body[:tasks].count).to eq(5)
		end
	end

	describe 'GET /tasks/:id' do 
		let(:task) { create(:task, user_id: user.id) }

		before { get "/tasks/#{task.id}", params: {}, headers: headers }

		it 'returns  with code 200' do 
			expect(response).to have_http_status(200)
		end

		it 'returns  the json tasks' do 
			expect(json_body[:title]).to eq(task.title)
		end
	end

	describe 'POST /taks' do

		before do 
			post '/tasks/', params: { task: task_params }.to_json, headers: headers
		end  

		context 'when params is valid' do

			let(:task_params) { attributes_for(:task) }

			it 'returns status code 201' do
				expect(response).to have_http_status(201)
			end

			it 'saves the task in database' do
				expect(Task.find_by(title: task_params[:title])).not_to be_nil 
			end 

			it 'returns the json for created task' do
				expect(json_body[:title]).to eq(task_params[:title])
			end 

			it 'assigns the created task to the current user' do 
				expect(json_body[:user_id]).to eq(user.id)
			end 

		end 

		context 'when params is not valid' do

			let(:task_params) { attributes_for(:task, title: ' ' ) }

			it 'returns status code 422' do
				expect(response).to have_http_status(422)
			end

			it 'does not saves the task in database' do

				expect(Task.find_by(title: task_params[:title])).to be_nil 

			end 

			it 'returns the json error for title' do
				expect(json_body[:errors]).to have_key(:title)
			end 
						
		end 
	end	

	describe 'PUT /task/:id' do 

		let!(:task) { create(:task, user_id: user.id) }

		before do 
			put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
		end

		context 'when the params is valid' do 

			let(:task_params) { { title: 'New Task Title' } }

			it 'status code is 200' do 
				expect(response).to have_http_status(200)
			end

			it 'returns the json for updated task' do 

				expect(json_body[:title]).to eq(task_params[:title])
			end

			it 'updates the task in the database' do 
				expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
			end
		end 


		context 'when the params are invalid' do 

			let(:task_params) { { title: '' } }

			it 'status code is 422' do 
				expect(response).to have_http_status(422)
			end

			it 'returns the json error for the title' do 
				expect(json_body[:errors]).to have_key(:title)
			end

			it 'does not updates the task in the database' do 
				expect( Task.find_by(title: task_params[:title]) ).to be_nil
			end
		end 

	end

	describe 'DELETE /task/:id' do 

		let!(:task) { create(:task, user_id: user.id) }

		before do 
			put "/tasks/#{task.id}", params: {}, headers: headers
		end

		# it 'status code is 204' do 
		# 	expect(response).to have_http_status(204)
		# end

		# it 'removes the task from the database' do 
		# 	expect(Task.find(task.id)).to raise_error(ActiveRecord::RecordNotFound)
		# end

	end
end