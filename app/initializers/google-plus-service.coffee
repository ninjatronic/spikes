GooglePlusInitializer =
  name: 'google-plus-service'
  initialize: (container, app) ->
    app.inject 'route', 'googlePlusService', 'service:google-plus'
    app.inject 'controller', 'googlePlusService', 'service:google-plus'

`export default GooglePlusInitializer`
