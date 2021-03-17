require_relative '../acceptance_helper'

feature 'Edit answer', '
In order to change answer
As a user and creator
I want to edit my answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }
  given!(:answer) { create(:answer, { question: question, user: user }) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "try to edit other user's answer" do
    user_2 = create(:user)
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'answer_body', with: 'edited answer'
        click_on 'Save'
        visit question_path(question)

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end
  end
end