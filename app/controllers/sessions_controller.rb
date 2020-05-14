class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Looks like your email or password is invalid'
      render :new
    end
  end

  def update
    current_user.update(github_info)
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def gather_github_token
    request.env['omniauth.auth']['credentials']['token']
  end

  def gather_github_uid
    request.env['omniauth.auth']['uid']
  end

  def gather_github_handle
    request.env['omniauth.auth']['info']['nickname']
  end

  def github_info
    { github_token: gather_github_token, github_uid: gather_github_uid,
      github_handle: gather_github_handle }
  end
end
