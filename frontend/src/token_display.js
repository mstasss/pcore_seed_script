import { useContext } from "react";
import { AuthContext } from "./procore/auth";

export default function TokenDisplay(params) {
  const { accessToken } = useContext(AuthContext);

  return <div>{accessToken}</div>;
}
