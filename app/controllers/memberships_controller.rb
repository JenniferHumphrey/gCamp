class MembershipsController < PrivateController
  before_action :find_and_set_project
  before_action :set_membership, only: [:update, :destroy]
  before_action :verify_min_one_owner, only: [:update, :destroy]
  before_action :ensure_membership

  def index
    @membership = @project.memberships.new
  end

  def create
    membership = @project.memberships.new(membership_params)
    if membership.save
      flash[:notice] = "#{membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(@project)
    else
      @membership = membership
      render :index
    end
  end

  def update
    if @membership.update(membership_params)
      flash[:notice] = "#{@membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(@project)
    else
      @membership = membership
      render :index
    end
  end

  def destroy
    @membership.destroy
    flash[:notice] = "#{membership.user.full_name} was successfully removed"
    redirect_to project_memberships_path(@project)
  end

  private

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def verify_min_one_owner
    @membership = Membership.find(params[:id])
    if @membership.role == "Owner" && @project.memberships.where(role: "Owner").count <= 1
      flash[:warning] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@membership.project_id)
    end
  end

  def ensure_membership
    project = Project.find(params[:project_id])
    unless project.has_membership?(current_user)
      flash[:warning] = "You do not have access to that project"
      redirect_to projects_path
    end
  end
end
