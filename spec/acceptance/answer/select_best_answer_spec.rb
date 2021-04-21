require_relative '../acceptance_helper'

feature 'Select best answer', '
In order to change order of answers
As a user and creator of question
I want to select best answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }
  given!(:answer1) { create(:answer, { question: question, user: user }) }
  given!(:answer2) { create(:answer, { question: question, user: user }) }
  given!(:answer3) { create(:answer, { question: question, user: user }) }

  scenario 'try to select best answer', js: true do
    sign_in user
    visit question_path(question)

    within ".body_answer_#{answer1.id}" do
      click_button 'Select answer as best'
    end
    visit question_path(question)
    within ".body_answer_#{answer1.id}" do
      expect(page).to have_content 'Best'
    end
  end

  scenario 'Unauthenticated user tries to select' do
    visit question_path(question)

    expect(page).to_not have_button 'Select as best'
  end

  scenario "Authenticated user tries to select best answer of another user's question" do
    user_2 = create(:user)
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_button 'Select answer as best'
  end
end
