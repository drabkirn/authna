// Fetch Appza Info - GET appzas/:id
export const fetchAppzaInfo = (id) => {
  return (dispatch) => {
    var myHeaders = {
      'Content-Type': 'application/json',
      'User-Agent': 'Drabkirn Authna : Official Website : NA',
      'Accept': 'application/drabkirn.authna.v1'
    };
    
    fetch(`/appzas/${id}`, { method: 'GET', headers: myHeaders })
      .then((response) => {
        return response.json();
      }).then((res) => {
        if(res.errors){
          dispatch({
            type: 'FETCH_APPZA_INFO_API_ERROR',
            err: res
          });
        } else {
          dispatch({
            type: 'FETCH_APPZA_INFO_SUCCESS',
            payload: res
          });
        }
      }).catch((err) => {
        dispatch({
          type: 'FETCH_APPZA_INFO_ERROR',
          err: err
        });
      });
  };
};

export const authenticateAppzaUser = (appzaId, authToken, csrfToken) => {
  return (dispatch) => {
    var myHeaders = {
      'Content-Type': 'application/json',
      'User-Agent': 'Drabkirn Authna : Official Website : NA',
      'Accept': 'application/drabkirn.authna.v1',
      'Authorization': authToken,
      'X-CSRF-Token': csrfToken
    };
    
    var myBody = {
      "appza":{
        "id": appzaId,
      }
    };
    
    fetch('/auth/appzas/login', { method: 'POST', headers: myHeaders, body: JSON.stringify(myBody)})
      .then((response) => {
        return response.json();
      }).then((res) => {
        if(res.errors){
          dispatch({
            type: 'AUTHENTICATE_APPZA_USER_API_ERROR',
            err: res
          });
        } else {
          dispatch({
            type: 'AUTHENTICATE_APPZA_USER_SUCCESS',
            payload: res
          });
        }
      }).catch((err) => {
        dispatch({
          type: 'AUTHENTICATE_APPZA_USER_ERROR',
          err: err
        });
      });
  };
}