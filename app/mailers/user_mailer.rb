class UserMailer < ApplicationMailer
  def sing_in(email)
    @email = email
    mail(to: email, subject: 'Confirm this email')
  end
end
