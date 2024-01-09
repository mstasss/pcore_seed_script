import React, { createContext, useState } from "react";

const OAUTH_URL = "https://sandbox.procore.com/oauth/token";

export const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [accessToken, setAccessToken] = useState(null);

  const [clientId, setClientId] = useState(null);
  const [clientSecret, setClientSecret] = useState(null);

  const handleSubmit = async () => {
    const tokenResponse = await fetch(OAUTH_URL, {
      method: "POST",
      body: {
        grant_type: "client_credentials",
        client_id: clientId,
        client_secret: clientSecret
      }
    });

    console.log(tokenResponse);
  };

  const credentialsForm = () => {
    return (
      <div>
        <h2>Enter your API credentials</h2>

        <label htmlFor="client_id">Client ID</label>
        <input
          type="text"
          name="client_id"
          id="client_id"
          onChange={(e) => setClientId(e.target.value)}
        />

        <label htmlFor="client_secret">Client Secret</label>
        <input
          type="text"
          name="client_secret"
          id="client_secret"
          onChange={(e) => setClientSecret(e.target.value)}
        />

        <input type="submit" value="Get Access" onClick={handleSubmit} />
      </div>
    );
  };

  return (
    <AuthContext.Provider
      value={{
        accessToken,
        setAccessToken
      }}
    >
      {accessToken ? children : credentialsForm()}
    </AuthContext.Provider>
  );
};
