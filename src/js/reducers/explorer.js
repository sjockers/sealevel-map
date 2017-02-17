import {
  SHOW_STATION_DETAILS,
  REQUEST_STATION_DETAIL_DATA,
  RECEIVE_STATION_DETAIL_DATA,
  SHOW_STATION_LIST
} from '../actions/explorer'

const explorerReducer = (state = {}, action) => {
  console.log(action.type, action)

  switch (action.type) {
    case REQUEST_STATION_DETAIL_DATA:
      return {
        ...state,
        isFetching: true
      }
    case RECEIVE_STATION_DETAIL_DATA:
      return {
        ...state,
        isFetching: false
      }
    case SHOW_STATION_DETAILS:
      return {
        ...state,
        station: action.data,
        country: null,
        continent: null
      }
    case SHOW_STATION_LIST:
      return {
        ...state,
        station: null,
        items: action.data,
        country: action.country,
        continent: action.continent
      }
    default:
      return state
  }
}

export default explorerReducer
