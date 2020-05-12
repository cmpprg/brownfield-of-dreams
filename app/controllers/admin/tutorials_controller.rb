class Admin::TutorialsController < Admin::BaseController
  def new
    @tutorial = Tutorial.new
  end

  def create
    @tutorial = Tutorial.new(create_tutorial_params)
    @tutorial.save ? happy_new_tutorial(@tutorial) : sad_new_tutorial(@tutorial)
  end

  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def update
    tutorial = Tutorial.find(params[:id])
    if tutorial.update(tutorial_params)
      flash[:success] = "#{tutorial.title} tagged!"
    end
    redirect_to edit_admin_tutorial_path(tutorial)
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    flash[:success] = "#{tutorial.title} tagged!" if tutorial.destroy
    redirect_to admin_dashboard_path
  end

  private

  def tutorial_params
    params.require(:tutorial).permit(:tag_list)
  end

  def create_tutorial_params
    params.require(:tutorial).permit(:title, :description, :thumbnail)
  end

  def happy_new_tutorial(tutorial)
    flash[:success] = 'Successfully created tutorial.'
    redirect_to tutorial_path(tutorial)
  end

  def sad_new_tutorial(tutorial)
    flash[:error] = tutorial.errors.full_messages.to_sentence
    render action: :new
  end
end
