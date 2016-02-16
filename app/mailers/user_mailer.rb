class UserMailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'

  def email_validation(user)
    @user = user
    mail(:to => user.email,
    :subject => 'Validate Account')
  end

  def email_password(user, password)
    @password = password
    mail(:to => user.email,
    :subject => 'New Password')
  end

  def send_firetalk_invite(firetalk, user)
    @firetalk = firetalk
    @user = user
    mail(:to => @user.email,
    :subject => "You've been challenged to a firetalk!")
  end
end
