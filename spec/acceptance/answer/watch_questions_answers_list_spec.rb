require_relative '../acceptance_helper'

feature 'Watch questions and answers list', '
In order to see questions and answers list
As an guest
I want to see questions and answers list
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, { user: user }) }
  given!(:answer) { create(:answer, { question: question, user: user }) }

  scenario 'User and creator watches questions and answers list' do
    sign_in(user)
    visit '/questions'
    expect(page).to have_content 'MyString'

    click_on 'Show'

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'Delete'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyBodyText'
    expect(page).to have_content 'All questions'
  end

  scenario 'Guest watches questions and answers list' do
    visit '/questions'
    expect(page).to have_content 'MyString'
    click_on 'Show'
    expect(page).to have_content 'MyString'
    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyBodyText'
    expect(page).to have_content 'All questions'
  end

  scenario 'Guest open page of empty questions list' do
    DatabaseCleaner.clean

    visit '/questions'

    expect(page).to_not have_content 'MyString'
    expect(page).to have_content 'Ask question'
  end
end
