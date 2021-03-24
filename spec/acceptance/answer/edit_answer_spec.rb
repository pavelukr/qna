require_relative '../acceptance_helper'

feature 'Edit answer', '
In order to change answer
As a user and creator
I want to edit my answer
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }
  given!(:answer) { create(:answer, { question: question, user: user }) }

  scenario "Unauthenticated user try to edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated user try to edit other user's answer" do
    user_2 = create(:user)
    sign_in(user_2)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Authenticated user try to edit his answer', js: true do
    sign_in user
    visit question_path(question)
    click_on 'Edit'

    within('.answers-all') do
      within('.container-answer') do
        within('.row-answer') do
          within('.edit-answer-row') do
            within('.form-edit-answer') do
              fill_in 'answer[body]', with: 'edited answer'
              find('#edit-save-answer-link').click
            end
          end
        end
      end
    end
    visit question_path(question)
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'edited answer'
  end
end
