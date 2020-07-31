require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {build(:user)}

	it { expect(user).to respond_to(:email) }
	it {is_expected.to validate_presence_of(:email)}
	it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
	it {is_expected.to validate_confirmation_of(:password)}
	it {is_expected.to allow_value('email@padrao.com').for(:email)}
end