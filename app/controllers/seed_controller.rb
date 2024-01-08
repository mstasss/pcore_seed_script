class SeedController < ApplicationController
  # Company ID of sandbox company
  SANDBOX_COMPANY_ID = 4264590

  def create
    # TODO: How do we determine these properly?
    # company_id = params[:company_id]
    # project_id = params[:project_id]

    company_id = SANDBOX_COMPANY_ID
    project_id = nil

    project_seeder = ProjectSeeder.new(company_id: company_id, project_id: project_id)
    project_seeder.run

    render json: { message: 'Success' }, status: :ok
  rescue => e # TODO: Rescue specific errors
    render json: { message: e.message }, status: :internal_server_error
  end
end
