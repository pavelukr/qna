require 'rails_helper'

feature 'Watch questions list', '
In order to see questions list
As an guest
I want to see questions list
' do

  scenario 'Guest watches questions list' do
    user = create(:user)
    create :question, { user: user }
    visit '/questions'

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'Ask question'
  end

  scenario 'Guest open page of empty questions list' do
    visit '/questions'

    expect(page).to_not have_content 'MyString'
    expect(page).to have_content 'Ask question'
  end
end
