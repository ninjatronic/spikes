`import Ember from 'ember'`
`import Application from '../../app'`
`import Router from '../../router'`
`import config from '../../config/environment'`

startApp = (attrs) ->

  application = null

  attributes = Ember.merge {}, config.APP
  attributes = Ember.merge attributes, attrs

  Ember.run ->
    application = Application.create attributes
    application.setupForTesting()
    application.injectTestHelpers()

  return application

`export default startApp`
