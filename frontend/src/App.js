import "./styles.css";

import { AuthProvider } from "./procore/auth.js";
import TokenDisplay from "./token_display";

// index.js connects the page to our app ("App")
// App.js is where we begin to describe our app
// Open the React Dev Tools tab to see how code is interpreted into a component tree

export const App = () => {
  return (
    <div className="App">
      <h1>Procore Project Seeder</h1>

      <AuthProvider>
        <TokenDisplay />
      </AuthProvider>
    </div>
  );
};
