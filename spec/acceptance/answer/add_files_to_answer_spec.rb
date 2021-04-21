require_relative '../acceptance_helper'

feature 'Add files to answer', "
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated User adds file to answer' do
    visit question_path(question)
    expect(page).to_not have_button 'Send'
    expect(page).to_not have_field 'answer_body'
  end

  scenario 'Authenticated User adds file to answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Ask new answer'
    fill_in 'answer_body', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_button 'Send'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end