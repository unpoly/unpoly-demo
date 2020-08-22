class Projects::DeadlinesController < ApplicationController

  def edit
    load_project
    build_project
  end

  def update
    load_project
    build_project
    save_project(form: 'edit')
  end

  def show
    load_project
  end

  private

  def build_project
    @project ||= project_scope.build
    @project.attributes = project_attributes
  end

  def load_project
    @project ||= project_scope.find(params[:project_id])
  end

  def save_project(form:)
    if @project.save
      redirect_to @project
    else
      render form, status: :bad_request
    end
  end

  def project_scope
    Project.all
  end

  def project_attributes
    if (attrs = params[:project])
      attrs.permit(:deadline)
    else
      {}
    end
  end

end
