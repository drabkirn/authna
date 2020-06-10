let initState = {
  appza: null,
  appzas: null,
  isFetching: true,
  err: null,
  create_appza_err: null
};

const appzasReducer = (state = initState, action) => {
  switch (action.type){
    case 'FETCH_APPZA_INFO_SUCCESS':
      return {
        ...state,
        err: null,
        appza: action.payload.data,
        isFetching: false
      };
    case 'FETCH_APPZA_INFO_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        appza: null,
        isFetching: true
      };
    case 'FETCH_APPZA_INFO_ERROR':
      return {
        ...state,
        err: action.err.message,
        appza: null,
        isFetching: true
      };
    case 'FETCH_ALL_APPZAS_SUCCESS':
      return {
        ...state,
        err: null,
        appzas: action.payload.data,
        isFetching: false
      };
    case 'FETCH_ALL_APPZAS_API_ERROR':
      return {
        ...state,
        err: action.err.error ? action.err.error : action.err.errors,
        appzas: null,
        isFetching: true
      };
    case 'FETCH_ALL_APPZAS_ERROR':
      return {
        ...state,
        err: action.err.message,
        appzas: null,
        isFetching: true
      };
    case 'CREATE_APPZA_API_ERROR':
      return {
        ...state,
        create_appza_err: action.err.error ? action.err.error : action.err.errors
      };
    case 'CREATE_APPZA_ERROR':
      return {
        ...state,
        create_appza_err: action.err.message
      };
    default:
      return state;
  }
};


export default appzasReducer;