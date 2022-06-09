class ProjectsController < ApplicationController
  def create
    @user = current_user
    @project = Project.create(project_params)
    @project.user = @user
    if @project.save
      redirect_to edit_user_path(current_user), notice: 'A new project was created!'
    else
      render 'users/edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @user = @project.user
    @project.destroy
    redirect_to edit_user_path(@user)
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :url)
  end
end
