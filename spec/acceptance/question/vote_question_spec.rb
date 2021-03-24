require_relative '../acceptance_helper'

feature 'Edit question', '
In order to vote for some question
As a user
I want to search through list and vote
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }

  scenario 'Unauthenticated user tries to vote question' do
    visit '/questions'

    expect(page).to_not have_link 'Vote'
  end

  scenario 'Authenticated user tries to vote for his own question' do
    sign_in(user)
    visit '/questions'
    expect(page).to_not have_link 'Vote'
  end

  scenario 'Authenticated user and not creator tries to vote', js: true do
    user_2 = create(:user)
    sign_in(user_2)
    visit '/questions'
    expect(page).to have_link 'Vote'
    find('.vote-question-link').click
    expect(page).to have_link 'Vote for', visible: false
    expect(page).to have_link 'Vote against', visible: false
    binding.pry
    within('.question-container') do
      within('.question-row') do
        within('.links-question-voting') do
          within('.question-for') do
            find('.vote-for-question-link').click visible: false
          end
        end
      end
    end

  end
end
