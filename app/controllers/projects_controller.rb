class ProjectsController < AuthenticatedController

  def index
    @projects = Project.all.reject { |p| !p.owned_by?(current_user) && !p.users.include?(current_user) }
  end

  def show
    @current_project = Project.find(params[:id])
  end

  def set_client_hourly_rate
    user = User.find(params[:user_id])
    project = Project.find(params[:project_id])
    rate = (params[:rate].to_f*100).to_i

    user.set_client_hourly_rate project, rate
    redirect_to :back
  end

  def set_budget
    project = Project.find(params[:project_id])
    budget = (params[:budget].to_f*100).to_i

    project.budget = budget
    project.save!
    redirect_to :back
  end

  def add_owner
    project = Project.find(params[:project_id])
    if project.add_owner params[:email]
      flash[:notice] = "User added successfully."
    else
      flash[:error] = "User could not be added.\n 
        Either the user with given email address doesn't exist or he is already a project owner."
    end

    redirect_to project_path(project)
  end

  def remove_owner
    project = Project.find(params[:project_id])
    project.remove_owner params[:email]
    redirect_to project_path(project)
  end
end
