require_relative '../acceptance_helper'

feature 'Delete file to question', "
  In order to change my question
  As an question's author
  I'd like to be able to delete file
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticated User and creator deletes file' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete this file'
    expect(page).to_not have_link 'spec_helper.rb', href: attachment.file.url
  end

  scenario 'Authenticated User but no creator deletes file' do
    user2 = create :user
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Delete this file'

    expect(page).to have_link 'spec_helper.rb', href: attachment.file.url
  end

  scenario 'Non-authenticated User deletes file' do
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: attachment.file.url
    expect(page).to_not have_link 'Delete this file'
  end
end
