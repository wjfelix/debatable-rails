class UserMailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'

  def email_validation(user)
    @user = user
    mail(:to => "#{@user.email}", :subject => "Debatable E-mail Confirmation")
  end

  def email_password(user, password)
    @password = password
    mail(:to => user.email,
    :subject => 'New Password')
  end
end
