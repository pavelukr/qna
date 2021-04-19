class UserMailer < ApplicationMailer

  def sign_in_confirm(user)
    @user = user
    mail(to: @user.email, subject: 'Confirmation')
  end

  def new_questions_list(user, *questions)
    @user = user
    @questions = questions
    mail(to: @user.email, subject: 'Daily list of new questions')
  end

  def new_answer(user, answer)
    @user = user
    @questions = questions
    mail(to: @user.email, subject: 'Daily list of new questions')
  end
end
