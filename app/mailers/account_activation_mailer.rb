class AccountActivationMailer < ApplicationMailer
  default from: 'jesse&ryan@example.com'

  def inform(user)
    @user = user
    @message = 'Visit here to activate your account.'
    mail(to: user.email, subject: 'click and activate')
  end
end
