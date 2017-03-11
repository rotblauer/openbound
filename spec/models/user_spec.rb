require 'rails_helper'

RSpec.describe User, :type => :model do

  # Setup.
  it "has a valid factory" do # <-- both syntaxes explictly set to work in spec_helper.rb
  	expect(FactoryGirl.create(:new_user)).to be_valid
  end

  # Validate basic attributes.
  it "is invalid with a name that is too long" do
  	expect(FactoryGirl.build(:new_user, name: "a" * 51)).not_to be_valid
  end
  it "is invalid without an email" do
  	expect(FactoryGirl.build(:new_user, email: nil)).not_to be_valid
  end
  it "is invalid with non-.edu email address" do
  	expect(FactoryGirl.build(:new_user, email: 'isaac@bowdoin.com')).not_to be_valid
  end
  it "is invalid with an invalid email address" do
  	expect(FactoryGirl.build(:new_user, email: 'isaac@@bowdoin.edu')).not_to be_valid
  	expect(FactoryGirl.build(:new_user, email: 'isaac@bowdoin,edu')).not_to be_valid
  	expect(FactoryGirl.build(:new_user, email: 'isaac@@bow_doin.edu')).not_to be_valid
  	expect(FactoryGirl.build(:new_user, email: 'isaac_bowdoin.edu')).not_to be_valid
  end
  it "is invalid without a password" do
  	expect(FactoryGirl.build(:new_user, password: nil)).not_to be_valid
  end
  it "is invalid with a password longer than 6 characters" do
  	expect(FactoryGirl.build(:new_user, password: "a"*5 )).not_to be_valid
  end

  ## New user scenarios.
  # school_id
  it "creates school_id for user on #create with bowdoin.edu" do
  	user = FactoryGirl.create(:new_user)
  	expect(user.school_id).to be_truthy
  end
  it "creates school_id for user on #create with nowhere.edu" do
  	user = FactoryGirl.create(:new_user, email: "isaac@nowhere.edu")
  	expect(user.school_id).to be_truthy # <-- sets school_id => 666666
  end
  # activation_digest
  it "creates activation_digest on #create" do
  	user = FactoryGirl.create(:new_user)
  	expect(user.activation_digest).to be_truthy
  end
  it "creates a new user with default attr superman => false" do
  	user = FactoryGirl.create(:new_user)
  	expect(user.superman).to eq(false)
  end

  it "should forget a user when logs out"

  it "should activate user with accurate activation digest"
  it "should not activate a user wrong or nil activation digest"

  it "should generate a password reset digest and send email containing it"
  it "should confirm reset digest and allow user to set new email"

  # Edit user scenarios.
  it "generates new slug when name changes" do
  	user = FactoryGirl.create(:isaac)
  	first_name = "#{user.name}"
  	first_slug = "#{user.slug}"
  	user.update(name: 'walter')
  	second_name = "#{user.name}"
  	second_slug = "#{user.slug}"
  	expect(first_name).not_to eq(second_name)
  	expect(first_slug).not_to eq(second_slug)
  end
  it "makes sure slugs are unique" do
  	cat = FactoryGirl.create(:new_user, email: "isaac@bowdoin.edu")
  	expect(FactoryGirl.build(:new_user, email: "isaac@bowdoin.edu")).not_to be_valid
  end

  it "should increment sign in count"

  it "should increment works_count when user creates a work"

  it "should correctly count number of user's works"
  it "should decrement works_count when user deletes a work"

  it "should increment bookmarks_count when user creates bookmark"
  it "should decrement bookmarks_count when user un-bookmarks"
  it "should increment bookmarks_count when user re-bookmarks"

end
