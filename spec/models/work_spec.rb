require 'rails_helper'

RSpec.describe Work, :type => :model do

  # Setup. 
  it "has a valid factory" do # <-- both syntaxes explictly set to work in spec_helper.rb
  	expect(FactoryGirl.create(:work)).to be_valid
  end

end
