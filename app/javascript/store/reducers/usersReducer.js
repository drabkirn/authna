let initState;
let getUserAuthToken = localStorage.getItem("authna_auth_token");
if(getUserAuthToken) {
  initState = {
    user_auth_token: getUserAuthToken,
    user: null,
    isFetching: false,
    err: null,
    resend_email_confirmation: false
  };
}
else{
  initState = {
    user_auth_token: null,
    user: null,
    isFetching: true,
    err: null,
    resend_email_confirmation: false
  };
}

const usersReducer = (state = initState, action) => {
  switch (action.type){
    case 'CREATE_USER_ACCOUNT_SUCCESS':
      localStorage.setItem("authna_auth_token", action.payload.data.auth_token);
      return {
        ...state,
        err: null,
        user_auth_token: action.payload.data.auth_token,
        user: null,
        isFetching: false
      };
    case 'CREATE_USER_ACCOUNT_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'CREATE_USER_ACCOUNT_ERROR':
      return {
        ...state,
        err: action.err.message,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_SUCCESS':
      localStorage.setItem("authna_auth_token", action.payload.data.auth_token);
      return {
        ...state,
        err: null,
        user_auth_token: action.payload.data.auth_token,
        user: null,
        isFetching: false
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_ERROR':
      return {
        ...state,
        err: action.err.message,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_SUCCESS':
      localStorage.setItem("authna_auth_token", action.payload.data.auth_token);
      return {
        ...state,
        err: null,
        user_auth_token: action.payload.data.auth_token,
        user: null,
        isFetching: false
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_ERROR':
      return {
        ...state,
        err: action.err.message,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'FETCH_USER_INFO_SUCCESS':
      return {
        ...state,
        err: null,
        user: action.payload.data,
        isFetching: false
      };
    case 'FETCH_USER_INFO_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'FETCH_USER_INFO_ERROR':
      return {
        ...state,
        err: action.err.message,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'AUTHENTICATE_APPZA_USER_SUCCESS':
      return {
        ...state,
        err: null,
        isFetching: false
      };
    case 'AUTHENTICATE_APPZA_USER_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    case 'AUTHENTICATE_APPZA_USER_ERROR':
      return {
        ...state,
        err: action.err.message,
        user_auth_token: null,
        user: null,
        isFetching: true
      };
    default:
      return state;
  }
};


export default usersReducer;