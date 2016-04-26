require 'rails_helper'

RSpec.describe School, :type => :model do
  it 'has a decent factory' do 
  	expect(FactoryGirl.create(:harvard)).to be_valid
  end
  ### puts ECONN refused -- something error with Solr
end
