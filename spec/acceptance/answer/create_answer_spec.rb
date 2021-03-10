require 'rails_helper'

feature 'Create answer', '
In order to write answer to the question
As an authenticated user
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user answers to the question' do
    sign_in(user)
    create_question
    create_answer

    expect(page).to have_content 'Test test'
  end

  scenario 'Non-authenticated user answers to the question' do
    create :question, { user: user }
    visit '/questions'
    click_on 'Show'
    click_on 'Send'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
