require 'rails_helper'

feature 'User signs out', '
  In order to have ability finish session
As an user
I want have an ability to sign out
' do

  given(:user) { create(:user) }

  scenario 'Registered user trying to sign out' do
    sign_in(user)
    click_on 'Exit'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-logged user trying to sign out' do
    visit '/questions'
    expect(page).to_not have_link 'Exit'
  end
end
