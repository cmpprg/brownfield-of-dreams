class InvitesController < ApplicationController
  def new; end

  def create
    invitee = get_email_and_name
    invitee[:email] ? send_invite(invitee) : no_email
    redirect_to '/dashboard'
  end

  private

  def get_user_info(username)
    GithubV3API.new(current_user.github_token, username).user_info
  end

  def get_email_and_name
    info ||= get_user_info(params[:q_username])
    { email: info[:email], name: info[:name] }
  end

  def send_invite(invitee)
    InviteMailer.invite(invitee).deliver_now
    flash[:success] = 'Successfully sent invite!'
  end

  def no_email
    flash[:notice] = "The Github user you selected doesn't have an email address associated with their account."
  end
end
