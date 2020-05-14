class InviteMailer < ApplicationMailer
  default from: 'brownfield@example.com'

  def invite(params)
    @name = params[:name]
    @sender_name = params[:sender_name]
    mail(to: params[:email], subject: 'Join us.')
  end
end
