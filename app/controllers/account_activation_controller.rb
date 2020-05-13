class AccountActivationController < ApplicationController
  def show
    user = User.find(params[:id])
    user.activate_account
  end
end
