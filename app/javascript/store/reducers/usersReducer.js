let initState;
let getUser = localStorage.getItem("authna_user");
if(getUser){
  initState = {
    user: JSON.parse(getUser),
    isFetching: false,
    err: null,
    resend_email_confirmation: false
  };
}
else{
  initState = {
    user: null,
    isFetching: true,
    err: null,
    resend_email_confirmation: false
  };
}

const usersReducer = (state = initState, action) => {
  switch (action.type){
    case 'CREATE_USER_ACCOUNT_SUCCESS':
      localStorage.setItem("authna_user", JSON.stringify(action.payload.data));
      return {
        ...state,
        err: null,
        user: action.payload.data,
        isFetching: false
      };
    case 'CREATE_USER_ACCOUNT_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user: null
      };
    case 'CREATE_USER_ACCOUNT_ERROR':
      return {
        ...state,
        err: action.err.message,
        user: null
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_SUCCESS':
      localStorage.setItem("authna_user", JSON.stringify(action.payload.data));
      return {
        ...state,
        err: null,
        user: action.payload.data,
        isFetching: false
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user: null
      };
    case 'CREATE_USER_SESSION_WITH_EMAIL_ERROR':
      return {
        ...state,
        err: action.err.message,
        user: null
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_SUCCESS':
      localStorage.setItem("authna_user", JSON.stringify(action.payload.data));
      return {
        ...state,
        err: null,
        user: action.payload.data,
        isFetching: false
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        user: null
      };
    case 'CREATE_USER_SESSION_WITH_USERNAME_ERROR':
      return {
        ...state,
        err: action.err.message,
        user: null
      };
    default:
      return state;
  }
};


export default usersReducer;