class ProjectSeeder
  def initialize(company_id:, project_id:)
    @company_id = company_id
    @project_id = project_id
  end

  def run(data)
    # here we should have all the data from the UI
    # we can use the Procore API client to create a vendor
    #
    # vendor = procore_client.create_vendor(data[:vendor][:name])
    # OR
    # vendor = procore_client.create_vendor(RandomNameGenerator.generate_fake_name)
    #
    # we can potentially use the created vendor in following steps
  end

  private

  def procore_client
    @procore_client ||= Procore::ApiClient.new(@company_id)
  end
end
