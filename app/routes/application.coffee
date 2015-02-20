`import Ember from 'ember'`


ApplicationRoute = Ember.Route.extend

  beforeModel: ->
    Kinvey.ping()


`export default ApplicationRoute`
