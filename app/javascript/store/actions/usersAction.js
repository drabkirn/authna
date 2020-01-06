// Create a New User - Signup
export const createNewUserAccount = (email, username, password, password_confirmation, csrfToken) => {
  return (dispatch) => {
    var myHeaders = {
      'Content-Type': 'application/json',
      'User-Agent': 'Drabkirn Authna : Official Website : NA',
      'Accept': 'application/drabkirn.authna.v1',
      'X-CSRF-Token': csrfToken
    };
    
    var myBody = {
      "user":{
        "email": email,
        "username": username,
        "password": password,
        "password_confirmation": password_confirmation
      }
    };
    
    fetch('/auth/signup', { method: 'POST', headers: myHeaders, body: JSON.stringify(myBody)})
      .then((response) => {
        return response.json();
      }).then((res) => {
        if(res.errors){
          dispatch({
            type: 'CREATE_USER_ACCOUNT_API_ERROR',
            err: res
          });
        } else {
          dispatch({
            type: 'CREATE_USER_ACCOUNT_SUCCESS',
            payload: res
          });
        }
      }).catch((err) => {
        dispatch({
          type: 'CREATE_USER_ACCOUNT_ERROR',
          err: err
        });
      });
  };
};


// Create a new User Session With Email - Login with Email
export const createNewUserSessionWithEmail = (email, password, otp_code_token, csrfToken) => {
  return (dispatch) => {
    var myHeaders = {
      'Content-Type': 'application/json',
      'User-Agent': 'Drabkirn Authna : Official Website : NA',
      'Accept': 'application/drabkirn.authna.v1',
      'X-CSRF-Token': csrfToken
    };
    
    var myBody = {
      "user":{
        "email": email,
        "password": password,
        "otp_code_token": otp_code_token
      }
    };
    
    fetch('/auth/login', { method: 'POST', headers: myHeaders, body: JSON.stringify(myBody)})
      .then((response) => {
        return response.json();
      }).then((res) => {
        if(res.errors){
          dispatch({
            type: 'CREATE_USER_SESSION_WITH_EMAIL_API_ERROR',
            err: res
          });
        } else {
          dispatch({
            type: 'CREATE_USER_SESSION_WITH_EMAIL_SUCCESS',
            payload: res
          });
        }
      }).catch((err) => {
        dispatch({
          type: 'CREATE_USER_SESSION_WITH_EMAIL_ERROR',
          err: err
        });
      });
  };
};


// Create a new User Session With Username - Login with Username
export const createNewUserSessionWithUsername = (username, password, otp_code_token, csrfToken) => {
  return (dispatch) => {
    var myHeaders = {
      'Content-Type': 'application/json',
      'User-Agent': 'Drabkirn Authna : Official Website : NA',
      'Accept': 'application/drabkirn.authna.v1',
      'X-CSRF-Token': csrfToken
    };
    
    var myBody = {
      "user":{
        "username": username,
        "password": password,
        "otp_code_token": otp_code_token
      }
    };
    
    fetch('/auth/login', { method: 'POST', headers: myHeaders, body: JSON.stringify(myBody)})
      .then((response) => {
        return response.json();
      }).then((res) => {
        if(res.errors){
          dispatch({
            type: 'CREATE_USER_SESSION_WITH_USERNAME_API_ERROR',
            err: res
          });
        } else {
          dispatch({
            type: 'CREATE_USER_SESSION_WITH_USERNAME_SUCCESS',
            payload: res
          });
        }
      }).catch((err) => {
        dispatch({
          type: 'CREATE_USER_SESSION_WITH_USERNAME_ERROR',
          err: err
        });
      });
  };
};