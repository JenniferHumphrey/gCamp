class CommentsController < ApplicationController

  def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to project_task_path(@task.project_id, @task)
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :task_id, :message)
  end

end
