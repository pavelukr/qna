require_relative '../acceptance_helper'

feature 'Edit question', '
In order to change question
As a user and creator
I want to edit my question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }

  scenario 'Unauthenticated user try to edit question' do
    visit '/questions'

    expect(page).to_not have_link 'Edit'
  end

  scenario "try to edit other user's question" do
    user_2 = create(:user)
    sign_in(user_2)
    visit '/questions'

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit '/questions'
    end

    scenario 'sees link to Edit' do
      expect(page).to have_link 'Edit'
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      fill_in 'question_title', with: 'edited question'
      fill_in 'question_body', with: 'edited test'
      click_on 'Save'

      visit '/questions'
      expect(page).to have_content 'edited question'
    end
  end
end
