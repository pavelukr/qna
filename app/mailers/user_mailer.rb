class UserMailer < ApplicationMailer

  def sign_in_confirm(user)
    @user = user
    mail(to: @user.email, subject: 'Confirmation')
  end
end
