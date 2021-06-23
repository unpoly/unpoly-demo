class CompaniesController < ApplicationController

  def new
    build_company
  end

  def create
    build_company
    save_company(event: 'company:created', form: 'new')
  end

  def edit
    load_company
    build_company
  end

  def update
    load_company
    build_company
    save_company(form: 'edit')
  end

  def show
    load_company
  end

  def index
    load_companies
  end

  def destroy
    load_company
    if @company.destroy
      redirect_to companies_path
    else
      redirect_to @company, alert: 'Could not delete company'
    end
  end

  private

  def build_company
    @company ||= company_scope.build
    @company.attributes = company_attributes
  end

  def load_company
    @company ||= company_scope.find(params[:id])
  end

  def save_company(form:)
    if up.validate?
      @company.valid? # run validations
      render form
    elsif @company.save
      redirect_to @company
    else
      render form, status: :bad_request
    end
  end

  def load_companies
    @companies = company_scope.order(:name).to_a
  end

  def company_scope
    current_tenant.companies
  end

  def company_attributes
    if (attrs = params[:company])
      attrs.permit(:name, :address)
    else
      {}
    end
  end

end
