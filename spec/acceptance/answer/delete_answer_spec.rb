require_relative '../acceptance_helper'

feature 'Delete answer', '
In order to change answers list
As a user and creator
I want to delete my answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, { user: user }) }
  given!(:answer) { create(:answer, { question: question, user: user }) }

  scenario 'Authenticated user and creator of
answer deletes one', js: true do
    sign_in(user)
    visit question_path(question)
    save_and_open_page
    find('.delete-answer-link').click
    save_and_open_page
    expect(page).to_not have_content 'Body body'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user but not creator tries to  delete answer' do
    user2 = create :user
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyText'
  end

  scenario 'Guest trying to delete question' do
    visit '/questions'
    click_on 'Show'

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end
end
