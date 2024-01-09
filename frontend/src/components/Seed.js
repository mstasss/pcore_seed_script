import React from "react";

const Seed = () => {
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
        project_id: 123456789,
        project_name: "Test Project",
        anything_can: "go_here"
      })
    });

    const data = await response.json();

    console.log("makeRequest response:", data);
  };

  return (
    <div className="Seed">
      <h2>Click the button to seed a project</h2>

      <button onClick={makeRequest}>Seed</button>
    </div>
  );
};

export default Seed;
