require_relative '../acceptance_helper'

feature 'User signs up', '
  In order to have ability asking question and answering
As an user
I want to have an ability to sign up
' do

  scenario 'New user trying to sign up' do
    sign_up('signup@test.com', '123456', '123456')

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'New user trying to sign up with taken email' do
    user = create :user
    sign_up(user.email, '123456', '123456')

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq '/users'
  end

  scenario 'New user trying to sign up with short password' do
    sign_up('signup@test.com', '12345', '12345')

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    expect(current_path).to eq '/users'
  end

  scenario 'New user trying to sign up with another password confirmation' do
    sign_up('signup@test.com', '123456', '1234566')

    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(current_path).to eq '/users'
  end
end
