class UsersController < ApplicationController
  def show
    @bookmarks_collection = UserVideo.get_bookmarks(current_user)
    return unless github_token_present?

    @repos = RepositoryFactory.new(current_user).return_collection
    @followers = FollowersFactory.new(current_user).return_collection
    @followees = FolloweesFactory.new(current_user).return_collection
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save ? create_happy_path(@user) : create_sad_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end

  def create_happy_path(user)
    session[:user_id] = user.id
    create_happy_flash(user)
    send_activation_email(user)
    please_activate_flash
    redirect_to dashboard_path
  end

  def create_sad_path(user)
    create_sad_flash(user)
    render action: :new
  end

  def please_activate_flash
    mess = 'This account has not yet been activated. Please check your email.'
    flash[:activation_notice] = mess
  end

  def create_happy_flash(user)
    flash[:notice] = "Logged in as #{user.first_name} #{user.last_name}"
  end

  def create_sad_flash(user)
    flash[:error] = user.errors.full_messages.to_sentence
  end

  def send_activation_email(user)
    AccountActivationMailer.inform(user).deliver_now
  end
end
