let initState = {
  appza: null,
  isFetching: true,
  err: null
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
    default:
      return state;
  }
};


export default appzasReducer;