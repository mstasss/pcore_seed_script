# Script that uses the API client to programatically create example data.

# Load the .env file so we can use the environment variables
require 'dotenv'
Dotenv.load

# Load the api_client.rb file so we can use the ApiClient class
require_relative 'api_client'

# Other dependencies
require 'logger'

# Enable HTTP logging if DEBUG=true
# https://github.com/httprb/http/wiki/Logging-and-Instrumentation
if ENV['DEBUG'] == 'true'
  HTTP.default_options = HTTP::Options.new(
    features: {
      logging: {
        logger: Logger.new($stdout)
      }
    }
  )
end

# Instantiate a new api client for the sandbox company.
client = ApiClient.new

# Use the client to do whatever
# Write loops, methods, random data generation, etc.

# Set example project, or create a new one
# projects = client.list_projects
# project_id = projects.first['id']
project_id = 117418

# Vendors
# NOTE: Make sure vendor has a primary contact (find out if this can be done via API)
# new_vendor = client.create_vendor('Example Vendor')
# vendor_id = new_vendor['id']
vendor_id = 2749483

# Commitments (purchase order)
#client.list_work_order_contracts
client.list_purchase_order_contracts

# Invoices
invoices = client.list_requisitions(project_id: project_id)

# CCO
client.list_commitment_change_orders

# PCCO
pcco = client.list_prime_change_orders(project_id: project_id)


puts '===================='
puts 'vendor:'
puts vendor_id
puts
puts 'invoices:'
puts invoices
puts

puts 'Done!'