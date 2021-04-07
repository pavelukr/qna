class UserMailer < ApplicationMailer

  def sing_in_mailer(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm this email')
  end
end
