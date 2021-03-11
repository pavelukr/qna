require 'rails_helper'

feature 'Delete question', '
In order to change questions list
As a user and creator
I want to delete my question
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }

  scenario 'Authenticated user and creator of
question deletes one', js: true do
    sign_in(user)
    visit '/questions'
    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_content 'MyString'
    expect(current_path).to eq '/questions'
  end

  scenario 'Authenticated user but not creator tries to delete question' do
    user2 = create :user
    sign_in(user2)
    visit '/questions'
    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyString'
    expect(current_path).to eq '/questions'
  end

  scenario 'Guest trying to delete question' do
    visit '/questions'

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyString'
    expect(current_path).to eq '/questions'
  end
end
