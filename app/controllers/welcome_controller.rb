class WelcomeController < ApplicationController
  def index
    params[:tag] ? tagged_tutorials_allowed : all_tutorials_allowed
  end

  private

  def tagged_tutorials_allowed
    tutorials = Tutorial.tagged_with(params[:tag]) if current_user
    tutorials = non_classroom_tutorials.tagged_with(params[:tag]) if visitor?
    @tutorials = tutorials.paginate(page: params[:page], per_page: 5)
  end

  def all_tutorials_allowed
    tutorials = Tutorial.all if current_user
    tutorials = non_classroom_tutorials if visitor?
    @tutorials = tutorials.paginate(page: params[:page], per_page: 5)
  end

  def non_classroom_tutorials
    Tutorial.where(classroom: false)
  end
end
