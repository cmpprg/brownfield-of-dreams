class InviteMailer < ApplicationMailer
  default from: 'brownfield@example.com'

  def invite(invitee)
    @name = invitee[:name]
    mail(to: invitee[:email], subject: 'Join us.')
  end
end
