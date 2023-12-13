// Replace these with your own values.

const OAUTH_URL = "https://sandbox.procore.com/oauth/token";
const BASE_API_URL = "https://sandbox.procore.com/rest/v1.0/";
const SANDBOX_COMPANY_ID = 4264590; // Your Procore company ID

async function getVendor(vendorId) {
  // 1. Obtain an access token
  const tokenResponse = await fetch(OAUTH_URL, {
    body: {
      grant_type: "client_credentials",
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET
    }
  });

  const accessToken = tokenResponse.data.access_token;

  console.log(accessToken);

  // 2. Use the access token to create a new vendor
  const response = await fetch(`${BASE_API_URL}vendors/${vendorId}`, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Procore-Company-Id": `${SANBOX_COMPANY_ID}`
    }
  });

  return response.data;
}

