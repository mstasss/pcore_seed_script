class ProjectSeeder
  def initialize(company_id:, project_id:)
    @company_id = company_id
    @project_id = project_id
  end

  def run
    # vendor = procore_client.create_vendor(RandomNameGenerator.generate_fake_name)
  end

  private

  def procore_client
    @procore_client ||= Procore::ApiClient.new(@company_id)
  end
end
