require 'rails_helper'
include SpecTestHelper

RSpec.describe SessionsController, :type => :controller do

	it 'logs activated user in' do
		user = FactoryGirl.create(:isaac)
		login(user)
		expect(response).to redirect_to '/members/isaac'
		expect(controller.current_user).to eq user
	end
	it 'logs user out' do
		user = FactoryGirl.create(:isaac)
		login(user)
		expect(controller.current_user).to eq user
		logout(user)
		expect(response).to redirect_to root_url
		expect(controller.current_user).to eq nil
	end
	it 'does not log in user without activated account' do
		user = FactoryGirl.create(:new_user)
		login(user)
		expect(response).to redirect_to root_url
		expect(controller.current_user).to eq nil
	end
	it 'does not log in user with invalid email/password combo' do 
		user = FactoryGirl.create(:isaac)
		post :create, session: { email: user.email, password: "floofy"}
		expect(response).to render_template('index/signin')
		expect(controller.current_user).to eq nil
	end
	
end
