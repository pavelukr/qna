require 'rails_helper'

feature 'Create answer', '
In order to write answer to the question
As an authenticated user
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, { user: user }) }

  scenario 'Authenticated user answers to the question', js: true do
    sign_in(user)
    visit question_path(question)
    create_answer

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Body body'
    end
  end

  scenario 'Non-authenticated user answers to the question' do
    create :question, { user: user }
    visit '/questions'
    click_on 'Show'
    click_on 'Send'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
