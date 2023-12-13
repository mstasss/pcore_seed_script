require 'httparty'
require 'dotenv'
require './random_name_generator.rb'
Dotenv.load

class ProcoreApi
  OAUTH_URL = "https://sandbox.procore.com/oauth/token"
  BASE_API_URL = "https://sandbox.procore.com/rest/v1.0/"
  SANDBOX_COMPANY_ID = ENV['SANDBOX_COMPANY_ID']

  def self.get_vendor(vendor_id)
    response = api_request(:get, "vendors/#{vendor_id}")
    response.parsed_response
  end

  def self.create_vendor(vendor_data)
    response = api_request(:post, "vendors", vendor_data.merge({"company_id" => SANDBOX_COMPANY_ID}))
    response.parsed_response
  end

  private

  def self.api_request(method, endpoint, body = nil)
    access_token = fetch_access_token
    headers = {
      "Authorization" => "Bearer #{access_token}",
      "Procore-Company-Id" => SANDBOX_COMPANY_ID.to_s,
      "Content-Type" => "application/json"
    }

    options = { headers: headers }
    options[:body] = body.to_json if body

    HTTParty.send(method, "#{BASE_API_URL}#{endpoint}", options)
  end

  def self.fetch_access_token
    # Token caching logic could be added here
    response = HTTParty.post(OAUTH_URL,
                             headers: { "Content-Type" => "application/json" },
                             body: {
                               grant_type: "client_credentials",
                               client_id: ENV['CLIENT_ID'],
                               client_secret: ENV['CLIENT_SECRET']
                             }.to_json)
    response.parsed_response["access_token"]
  end
end


new_vendor_data = {
  name: generate_fake_name
  # Additional vendor data here
}

# CREATE A VENDOR

# begin
#   vendor = ProcoreApi.create_vendor(new_vendor_data)
#   puts "Vendor Created: #{vendor}"
# rescue => e
#   puts "Error creating vendor: #{e.message}"
# end

puts new_vendor_data
