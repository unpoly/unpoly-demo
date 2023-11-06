class TasksController < ApplicationController

  def new
    build_task
  end

  def create
    build_task
    save_task(event: 'task:created', form: 'new')
  end

  def edit
    load_task
    build_task
  end

  def update
    load_task
    build_task
    save_task(form: 'edit')
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

  def toggle_done
    load_task
    @task.toggle_done!
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

  def save_task(event: nil, form:)
    if up.validate?
      @task.valid? # run validations
      render form
    elsif @task.save
      up.layer.emit(event) if event
      redirect_to @task, notice: 'Task saved successfully'
    else
      render form, status: :bad_request
    end
  end

  def task_attributes
    if (attrs = params[:task])
      attrs.permit(:text, :done)
    else
      {}
    end
  end

end
