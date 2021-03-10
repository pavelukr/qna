require 'rails_helper'

feature 'Delete answer', '
In order to change answers list
As a user and creator
I want to delete my answer
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user and creator of
answer deletes one', js: true do
    sign_in(user)
    create_question
    create_answer

    click_on 'Delete'
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_content 'Answers'
  end

  scenario 'Authenticated user can not delete answer' do
    sign_in(user)
    create_question
    create_answer
    click_on 'Exit'
    user2 = create :user
    sign_in(user2)
    visit '/questions'
    click_on 'Show'

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'Body body'
  end

  scenario 'Guest trying to delete question' do
    question = create :question, { user: user }
    create :answer, { question: question, user: user }
    visit '/questions'
    click_on 'Show'

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end
end
