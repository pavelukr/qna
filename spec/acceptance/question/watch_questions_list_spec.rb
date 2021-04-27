require 'rails_helper'

feature 'Watch questions list', '
In order to see questions list
As an guest
I want to see questions list
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }

  scenario 'User and creator watches questions list' do
    sign_in(user)
    visit '/questions'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'Delete'

    click_on 'Show'

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyBodyText'
    expect(page).to have_content 'All questions'
  end

  scenario 'Guest watches questions list' do
    visit '/questions'

    click_on 'Show'

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyBodyText'
    expect(page).to have_content 'All questions'
  end

  scenario 'Guest open page of empty questions list' do
    DatabaseCleaner.clean

    visit '/questions'

    expect(page).to_not have_content 'MyString'
    expect(page).to_not have_content 'Show'
    expect(page).to have_content 'Ask question'
  end
end
