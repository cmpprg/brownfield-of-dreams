class UsersController < ApplicationController
  def show
    @repos = gather_repo_objects if github_token_present?
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Username already exists'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end

  def gather_repo_objects
    repos_info = GithubV3API.new(current_user.github_token).repo_info[0..4]
    RepositoryCollection.new(repos_info).return_collection
  end
end
