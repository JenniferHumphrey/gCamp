class CommentsController < ApplicationController

  def create
    task = Task.find(params[:task_id])
    comment = Comment.new(params.require(:comment).permit(:description).merge(
    task_id => task.id
    user_id  => user.id
    ))
    comment.save
    redirect_to project_task_path(task.project_id, task)
  end
end
