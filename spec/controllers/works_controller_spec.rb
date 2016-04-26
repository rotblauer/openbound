require 'rails_helper'

RSpec.describe WorksController, :type => :controller do
	describe 'GET #index' do 
		it 'renders the :index template'
	end

	describe 'GET #show' do 
		it 'gets the right work'
		it 'renders the :show template'
	end

	describe 'GET #edit' do 
		context 'without authentication' do
			it 'redirects to #show'
		end
		context 'with authentication' do 
			it 'renders the :edit template'
		end
	end
end
