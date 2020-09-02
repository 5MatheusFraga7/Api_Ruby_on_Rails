require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {build(:user)}

	it { expect(user).to respond_to(:email) }
	it {is_expected.to validate_presence_of(:email)}
	it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
	it {is_expected.to validate_confirmation_of(:password)}
	it {is_expected.to allow_value('email@padrao.com').for(:email)}
	it { is_expected.to validate_uniqueness_of(:auth_token) }

	describe '#info' do 
		it 'returns email and created_at' do 
			user.save!
			allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')

			expect(user.info).to eq("#{user.email} - #{user.created_at} - Token : abc123xyzTOKEN") 
		end
	end

	describe '#generate_athentication_token!' do 
		it 'generates unique auth token' do 
			allow(Devise).to receive(:friendly_token).and_return('abc123xyzTOKEN')

			user.generate_athentication_token!
			expect(user.auth_token).to eq('abc123xyzTOKEN')

		end

		it 'generates another auth token when the current auth token already as been taken' do
			allow(Devise).to receive(:friendly_token).and_return('abc123TOKENxyz', 'abc123TOKENxyz', 'the_new_token1') 
			existing_user = create(:user)
			user.generate_athentication_token!

			expect(user.auth_token).not_to eq(existing_user.auth_token)
		end
	end 
end
