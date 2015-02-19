`import config from 'spikes/config/environment'`

initialize = (container, application) ->
  Kinvey.init container, application,
    appKey: config.APP.KINVEY_APP_ID
    appSecret: config.APP.KINVEY_APP_SECRET

  application.inject 'controller', 'activeUser', 'user:active'
  application.inject 'route', 'activeUser', 'user:active'

KinveyInitializer =
  name: 'kinvey'
  initialize: initialize

`export {initialize}`
`export default KinveyInitializer`
