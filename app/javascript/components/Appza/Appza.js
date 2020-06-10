import React, { useEffect, useState } from 'react';
import { Link, Redirect } from 'react-router-dom';
import { useSelector, useDispatch } from "react-redux";

import { fetchAllAppzasInfo, createAppza } from '../../store/actions/appzasAction';

function Appza() {
  // Get the Redux Dispatch
  const dispatch = useDispatch();

  // Get the Redux state
  const store = useSelector(store => store);
  const { user } = store.users;
  const { appzas } = store.appzas;
  const createAppzaError = store.appzas.create_appza_err;
  const userAuthToken = store.users.user_auth_token;

  const [formState, setFormState] = useState({
    name: "",
    url: "",
    callback_url: "",
    accept_header: "",
    requires: {
      first_name: false,
      last_name: false,
      username: false,
      email: false
    }
  });

  useEffect(() => {
    if(user && user.admin) {
      dispatch(fetchAllAppzasInfo(userAuthToken));
    }
  }, [user]);

  if(!user || !user.admin) return <Redirect to="/" />;

  const handleInputChange = (e) => {
    if(e.target.type === 'checkbox') {
      setFormState({
        ...formState,
        requires: {
          ...formState.requires,
          [e.target.name]: e.target.checked ? true : false
        }
      });
    } else {
      setFormState({
        ...formState,
        [e.target.name]: e.target.value
      });
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const requiresArr = [];
    for(let a in formState.requires) {
      if(formState.requires[a]) requiresArr.push(a);
    }

    const csrfToken = document.querySelector('[name="csrf-token"]').getAttribute('content');
    dispatch(createAppza(formState.name, formState.url, formState.callback_url, formState.accept_header, requiresArr, userAuthToken, csrfToken));
  };

  return (
    <React.Fragment>
      <div>
        <h3>Your apps:</h3>
        {
          appzas && appzas.map((appza) => {
            return(
              <div key={ appza.id }>
                <p>Name: {appza.name} | URL: { appza.url } | Callback: { appza.callback_url } || accept_header: { appza.accept_header } | secret: { appza.secret } | requires: { appza.requires.join(", ") }</p>
              </div>
            )
          })
        }
      </div>

      <hr />

      <div>
        <h3>Create new App</h3>
        <form onSubmit={ (e) => handleSubmit(e) }>
          <div>
            <label htmlFor="appzaName">Name:</label>
            <input type="text" id="appzaName" name="name" value={ formState.name } onChange={ (e) => handleInputChange(e) } />
          </div>

          <div>
            <label htmlFor="appzaURL">URL:</label>
            <input type="text" id="appzaURL" name="url" value={ formState.url } onChange={ (e) => handleInputChange(e) } />
          </div>

          <div>
            <label htmlFor="appzaCallbackURL">Callback URL:</label>
            <input type="text" id="appzaCallbackURL" name="callback_url" value={ formState.callback_url } onChange={ (e) => handleInputChange(e) } />
          </div>

          <div>
            <label htmlFor="appzaAcceptHeader">Accept Header:</label>
            <input type="text" id="appzaAcceptHeader" name="accept_header" value={ formState.accept_header } onChange={ (e) => handleInputChange(e) } />
          </div>

          <div>
            <label>Requires:</label><br />
            <label htmlFor="appzaRFN">first_name:</label>
            <input type="checkbox" id="appzaRFN" name="first_name" checked={ formState.requires.first_name } onChange={ (e) => handleInputChange(e) } />
            <br />
            <label htmlFor="appzaRLN">last_name:</label>
            <input type="checkbox" id="appzaRLN" name="last_name" checked={ formState.requires.last_name } onChange={ (e) => handleInputChange(e) } />
            <br />
            <label htmlFor="appzaRUN">username:</label>
            <input type="checkbox" id="appzaRUN" name="username" checked={ formState.requires.username } onChange={ (e) => handleInputChange(e) } />
            <br />
            <label htmlFor="appzaREM">email:</label>
            <input type="checkbox" id="appzaREM" name="email" checked={ formState.requires.email } onChange={ (e) => handleInputChange(e) } />
          </div>

          <div>
            <button type="submit">Submit</button>
          </div>
        </form>

        {
          createAppzaError ? (
            <div>
              <p>{ createAppzaError.message }</p>
            </div>
          ) : ("")
        }
      </div>

      <div>
        <Link to="/dash">Back</Link>
      </div>
    </React.Fragment>
  );
}

export default Appza;