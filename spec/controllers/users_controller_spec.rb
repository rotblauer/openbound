
require 'rails_helper'
include SpecTestHelper

RSpec.describe UsersController, :type => :controller do

	before :each do
		@user = FactoryGirl.create(:isaac)
	end

	describe 'GET #show' do 
		context 'for signed-in user' do
			it 'assigns requested user to @user' do 
				login(@user)
				get :show, id: @user
				expect(assigns(:isaac)).to eq(@user)
			end
			it 'renders the :show template'
		end
		context 'for not-signed-in user' do
			it 'redirects to signin' do 
				get :show, id: @user
				expect(response).to render_template('index/signin')
			end
		end

	end

	describe 'POST #create' do 
		context 'with valid attributes' do 
			it 'saves the new user in the db'
			it 'redirects to root'
		end
		context 'with invalid attributes' do 
			it 'does not save the user in the db'
			it 're-renders the :new template'
		end
	end

end
