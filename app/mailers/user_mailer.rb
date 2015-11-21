class UserMailer < ActionMailer::Base
  def email_validation(user)
    @user = user
    mail(:to => "#{@user.email}", :subject => "Debatable E-mail Confirmation")
  end
end
