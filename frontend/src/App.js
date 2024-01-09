import React from "react";
import "./styles.css";

import Seed from "./components/Seed";

// index.js connects the page to our app ("App")
// App.js is where we begin to describe our app
// Open the React Dev Tools tab to see how code is interpreted into a component tree

const App = () => {
  return (
    <div className="App">
      <h1>Procore Project Seeder</h1>

      <Seed />
    </div>
  );
};

export default App;
