class ProjectsController < AuthenticatedController

  def index
    @projects = Project.all.reject { |p| !p.owned_by?(current_user) }
    @projects = Project.all
  end

  def show
    @current_project = Project.find(params[:id])
  end

  def add_owner
    project = Project.find(params[:project_id])
    project.add_owner params[:email]    
    redirect_to project_path(project)
  end

  def remove_owner
    project = Project.find(params[:project_id])
    project.remove_owner params[:email]
    redirect_to project_path(project)
  end
end