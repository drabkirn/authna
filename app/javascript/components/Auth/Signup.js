import React, { useState, useEffect } from 'react';
import { Link, Redirect } from 'react-router-dom';
import { useSelector, useDispatch } from "react-redux";

import './Auth.css';

import { createNewUserAccount, fetchUserInfo } from '../../store/actions/usersAction';

function Signup() {
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [firstName, setfirstName] = useState("");
  const [lastName, setlastName] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");

  // Get the Redux state
  const store = useSelector(store => store);
  const response = store.users;
  const userAuthToken = response.user_auth_token;

  useEffect(() => {
    if(userAuthToken) {
      dispatch(fetchUserInfo(userAuthToken));
    }
  }, [userAuthToken]);
  
  if(response.user) return <Redirect to="/dash" />;

  // Get the Redux Dispatch
  const dispatch = useDispatch();

  return (
    <React.Fragment>
      <div>
        <h1>Signup</h1>
        <Link to={"/"}>Login</Link>
      </div>

      <div>
        <form onSubmit={ (e) => {
            e.preventDefault();
            const csrfToken = document.querySelector('[name="csrf-token"]').getAttribute('content');
            dispatch(createNewUserAccount(email, username, firstName, lastName, password, passwordConfirmation, csrfToken));
          }
        }>
          <div>
            <label htmlFor="email">Email: </label>
            <input type="email" id="email" autoFocus autoComplete="email" onChange={ (e) => setEmail(e.target.value) } />  
          </div>

          <div>
            <label htmlFor="username">Username: </label>
            <input type="text" id="username" autoComplete="username" onChange={ (e) => setUsername(e.target.value) } />  
          </div>

          <div>
            <label htmlFor="firstName">firstName: </label>
            <input type="text" id="firstName" autoComplete="firstName" onChange={ (e) => setfirstName(e.target.value) } />  
          </div>

          <div>
            <label htmlFor="lastName">lastName: </label>
            <input type="text" id="lastName" autoComplete="lastName" onChange={ (e) => setlastName(e.target.value) } />  
          </div>

          <div>
            <label htmlFor="password">Password: </label>
            <input type="password" id="password" onChange={ (e) => setPassword(e.target.value) } />
          </div>
          <div>
            <label htmlFor="passwordConfirmation">Comfirm your password: </label>
            <input type="password" id="passwordConfirmation" onChange={ (e) => setPasswordConfirmation(e.target.value) } />
          </div>

          <br />
          
          {
            response.err ? (
              <div>
                {
                  response.err.message ? (
                    <div>
                      { "Error: " + response.err.message }
                    </div>
                  ) : ""
                }
              </div>
            ) : ("")
          }

          <div>
            <button>Signup</button>
          </div>
        </form>
      </div>
    </React.Fragment>
  );
}

export default Signup;