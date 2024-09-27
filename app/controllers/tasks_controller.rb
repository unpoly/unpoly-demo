class TasksController < ApplicationController

  def new
    build_task
  end

  def create
    build_task

    if @task.save
      redirect_to tasks_path, notice: 'Task added'
    else
      render 'new', status: :bad_request
    end
  end

  def edit
    load_task
    build_task
  end

  def update
    load_task
    build_task

    if @task.save
      redirect_to @task, notice: 'Task updated'
    else
      render 'edit', status: :bad_request
    end
  end

  def show
    load_task
  end

  def index
    load_tasks
  end

  def clear_done
    task_scope.clear_done!
    redirect_to tasks_path
  end

  def finish
    load_task
    @task.finish!
    redirect_to @task
  end

  def unfinish
    load_task
    @task.unfinish!
    redirect_to @task
  end

  private

  def load_tasks
    @tasks ||= task_scope.order(created_at: :desc).to_a
  end

  def task_scope
    current_tenant.tasks
  end

  def load_task
    @task ||= task_scope.find(params[:id])
  end

  def build_task
    @task ||= task_scope.build
    @task.attributes = task_attributes
  end

  def task_attributes
    if (attrs = params[:task])
      attrs.permit(:text, :done)
    else
      {}
    end
  end

  helper_method def open_task_count
    load_tasks
    @tasks.select(&:open?).size
  end

end
