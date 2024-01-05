require 'http'

# Service Account Credentials
SA_CLIENT_ID = ENV['SA_CLIENT_ID']
SA_CLIENT_SECRET = ENV['SA_CLIENT_SECRET']

# OAuth URL
OAUTH_URL = 'https://sandbox.procore.com/oauth/token'

BASE_API_URL = 'https://sandbox.procore.com/rest/'
DEFAULT_API_VERSION = 'v1.0'

# Company ID of sandbox company
SANBOX_COMPANY_ID = 4264590

class ApiClient
  # ApiClient is a class that handles HTTP requests to the Procore API.
  #
  # The client automatically authenticates with the API via #create_new_access_token.
  #

  # The initialize method is called behind the scenes when we call `ApiClient.new`
  # company_id = SANBOX_COMPANY_ID is a default argument, so we can call
  # `ApiClient.new` to create a new instance with @company_id = SANBOX_COMPANY_ID
  # or `ApiClient.new(123)` to create a new instance with @company_id = 123
  # This in essence ties each client instance to a specific company.
  def initialize(company_id = SANBOX_COMPANY_ID)
    @company_id   = company_id
    @access_token = create_new_access_token
  end

  def list_vendors
    get(
      build_url('/vendors'),
      company_id: @company_id
    )
  end

  def create_vendor(name)
    post(
      build_url('/vendors'),
      { company_id: @company_id, vendor: { name: name } }
    )
  end

  def list_projects
    get(
      build_url('/projects'),
      company_id: @company_id
    )
  end

  # Commitments (purchase order)
  # DEPRECATED https://developers.procore.com/reference/rest/v1/commitments?version=1.0
  # /work_order_contracts or /purchase_order_contracts can be used as a replacement
  def list_commitments
    raise 'Deprecated - use /work_order_contracts or /purchase_order_contracts instead'
  end

  # Work Order Contracts
  # https://developers.procore.com/reference/rest/v1/work-order-contracts?version=1.0
  # GET /rest/v1.0/work_order_contracts
  def list_work_order_contracts
  end

  # Purchase Order Contracts
  # https://developers.procore.com/reference/rest/v1/purchase-order-contracts?version=1.0
  # GET /rest/v1.0/purchase_order_contracts
  def list_purchase_order_contracts
  end

  # project_id
  # title
  # origin code
  def create_purchase_order_contract(
    project_id:,
    title:
  )
    post(
      build_url('/purchase_order_contracts'),
      {
        project_id: project_id,
        title: title
      }
    )
  end

  # Purchase Order Contract Line Items
  # https://developers.procore.com/reference/rest/v1/purchase-order-contract-line-items?version=1.0#create-purchase-order-contract-line-item
  # POST /rest/v1.0/purchase_order_contracts/{purchase_order_contract_id}/line_items
  def create_purchase_order_contract_line_item(
    project_id:,
    po_id:,
    dollar_amount:,
    cost_code_id:
  )
    post(
      build_url("/purchase_order_contract_line_items/#{po_id}/line_items"),
      {
        project_id: project_id,
        line_item: {
          dollar_amount: dollar_amount,
          cost_code_id: cost_code_id,
        }
      }
    )
  end

  # Commitment Change Orders
  # https://developers.procore.com/reference/rest/v1/commitment-change-orders?version=1.0
  # GET /rest/v1.0/projects/{project_id}/commitment_change_orders
  def list_commitment_change_orders
  end

  # Requisitions (subcontractor invoices)
  # https://developers.procore.com/reference/rest/v1/requisitions-subcontractor-invoices?version=1.0
  # GET /rest/v1.0/requisitions
  #
  # Parameters
  # project_id              integer*        Unique identifier for the project.
  # page                    integer         Page
  # per_page                integer         Elements per page
  # filters[id]             array[integer]  Return item(s) with the specified IDs.
  # filters[commitment_id]  integer         Commitment ID. Returns item(s) with the specified Commitment ID.
  # filters[period_id]      integer         Billing Period ID. Returns item(s) with the specified Billing Period ID.
  # filters[status]         string          Return item(s) with the specified Requisition (Subcontractor Invoice) status. Allowed values: draft under_review revise_and_resubmit approved approved_as_noted pending_owner_approval
  # filters[created_at]     string          Return item(s) created within the specified ISO 8601 datetime range.
  # filters[updated_at]     string          Return item(s) last updated within the specified ISO 8601 datetime range.
  # filters[origin_id]      string          Origin ID. Returns item(s) with the specified Origin ID.

  def list_requisitions(
    project_id:,
    page: 1,
    per_page: 100,
    filters: {}
  )
    get(
      build_url('/requisitions'),
      project_id: project_id,
      page: page,
      per_page: per_page,
      filters: filters
    )
  end

  def create_requisition
    # post(
    #   build_url('/requisitions'),
    #   {
    #     project_id: project_id,
    #     requisition: {
    #       commitment_id: commitment_id,
    #       period_id: period_id,
    #       origin_id: origin_id,
    # )
  end

  # Prime Contracts
  # https://developers.procore.com/reference/rest/v1/prime-contracts?version=1.0
  # GET /rest/v1.0/prime_contract
  def list_prime_contracts
  end

  # Prime Contract Change Orders
  def list_prime_contract_change_orders
  end

  # Prime Change Orders
  # https://developers.procore.com/reference/rest/v1/prime-change-orders?version=1.0
  # GET /rest/v1.0/projects/{project_id}/prime_change_orders
  # Returns all Prime Change Orders for the specified Project. This endpoint currently only supports projects using 1 and 2 tier change order configurations.
  #
  # Parameters
  # sort                       string   Direction (asc/desc) can be controlled by the presence or absence of '-' before the sort parameter. Allowed values: id, created_at
  # filters[id]                integer  Filter results by Change Order ID
  # filters[batch_id]          integer  Filter results by Change Order Batch ID
  # filters[legacy_package_id] integer  Filter results by legacy Change Order Package ID
  # filters[contract_id]       integer  Filter results by Contract ID
  def list_prime_change_orders(
    project_id:,
    sort: nil,
    filters: {}
  )
    get(
      build_url("/projects/#{project_id}/prime_change_orders"),
      sort: sort,
      filters: filters
    )
  end

  # Private methods are only accessible from within the class
  # It's a good idea to separate the internals of your class
  # from the 'public interface' - the methods that can be called from outside
  # This way, you can change the internals of your class without breaking
  # other code that uses it. Also, it makes the public interface smaller so it's easier to think about.
  private

  def create_new_access_token
    response = HTTP.post(
      OAUTH_URL,
      json: {
        grant_type: 'client_credentials',
        client_id: SA_CLIENT_ID,
        client_secret: SA_CLIENT_SECRET
      }
    )

    json = JSON.parse(response.body)

    json['access_token']
  end

  def get(uri, query_params = {})
    query_params.reject! { |_, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    uri.query = URI.encode_www_form(query_params) unless query_params.empty?

    response = HTTP.get(uri, headers: base_headers)
    JSON.parse(response.body)
  end

  def post(uri, body)
    response = HTTP.post(uri, headers: base_headers, json: body)
    JSON.parse(response.body)
  end

  def build_url(path, base_url: BASE_API_URL, api_version: DEFAULT_API_VERSION)
    url_string = "#{base_url.rjust(1, '/')}#{api_version}#{path.ljust(1, '/')}"
    URI.parse(url_string)
  end

  def base_headers
    {
      'Authorization' => "Bearer #{@access_token}",
      'Procore-Company-Id' => @company_id.to_s
    }
  end
end