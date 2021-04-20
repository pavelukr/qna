=begin
require_relative '../search_helper'

feature 'Search through all', "
  In order to illustrate desirable question
  As an user or guest
  I'd like to be able to do search
" do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, { user: user }) }

  scenario 'Non-authenticated User try to search' do
    visit questions_path
    click_on 'Search through questions'
    fill_in 'search', with: 'MyString'
    click_on 'Search question'
    expect(page).to have_content 'MyString'
  end
end
=end
