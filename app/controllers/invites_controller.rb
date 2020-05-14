class InvitesController < ApplicationController
  def new; end

  def create
    invitee = gather_email_params
    invitee[:email] ? send_invite : no_email
    redirect_to '/dashboard'
  end

  private

  def get_user_info(username)
    GithubV3API.new(current_user.github_token, username).user_info
  end

  def gather_email_params
    invitee ||= get_user_info(params[:q_username])
    { email: invitee[:email],
      name: invitee[:name],
      sender_name: get_user_info(current_user.github_handle)[:name] }
  end

  def send_invite
    InviteMailer.invite(gather_email_params).deliver_now
    flash[:success] = 'Successfully sent invite!'
  end

  def no_email
    message1 = "The Github user you selected doesn't have an "
    message2 = 'email address associated with their account.'
    flash[:notice] = "#{message1}#{message2}"
  end
end
