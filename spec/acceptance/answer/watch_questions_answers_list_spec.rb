require 'rails_helper'

feature 'Watch questions and answers list', '
In order to see questions and answers list
As an guest
I want to see questions and answers list
' do

  scenario 'Guest watches questions and answers list' do
    user = create(:user)
    question = create(:question, { user: user })
    answer = create(:answer, { question: question, user: user })
    visit '/questions'

    click_on 'Show'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyBodyText'
    expect(page).to have_content 'All questions'
  end

  scenario 'Guest open page of empty questions list' do
    visit '/questions'

    expect(page).to_not have_content 'MyString'
    expect(page).to have_content 'Ask question'
  end
end
