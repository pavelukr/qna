require_relative '../acceptance_helper'

feature 'Add files to question', %q(
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }

  scenario 'Non-authenticated User adds file to question' do
    visit new_question_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User adds file when asks question' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end