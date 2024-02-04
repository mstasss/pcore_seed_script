import React, { useState } from "react";

const Seed = () => {
  const [vendorName, setVendorName] = useState("default vendorName value");

  // every time the state changes, the component re-renders,
  // and this console.log statement is called
  console.log("vendor:", vendorName);

  const makeRequest = async () => {
    const authenticityToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    const response = await fetch("http://localhost:3000/seed", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": authenticityToken
      },
      body: JSON.stringify({
        // this is the data we're sending to the server
        data: {
          vendor: { name: vendorName }
        }
      })
    });

    if (response.ok) {
      console.log("response was ok");

      const responseData = await response.json();

      console.log("response from server:", responseData);
    } else {
      console.log("response was not ok");
    }
  };

  return (
    <div className="Seed">
      <h2>Click the button to seed a project</h2>

      <h2>Items to Create</h2>

      <div className="items">
        <div className="vendor">
          <h3>Vendor</h3>

          <input
            type="text"
            value={vendorName}
            onChange={(event) => {
              // every time the input changes, we update the state
              // event.target.value comes from the input element
              setVendorName(event.target.value);
            }}
          />
        </div>
      </div>

      <button onClick={makeRequest}>Seed</button>
    </div>
  );
};

export default Seed;
