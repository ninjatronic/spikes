`import Ember from 'ember'`
`import User from 'spikes/models/user'`


ApplicationController = Ember.Controller.extend

  hasActiveUser: Ember.computed.bool 'activeUser.id'

  actions:
    login: ->
      @get 'googlePlusService'
      .login()
      .then (response) ->
        identity =
          _socialIdentity:
            google: response
        Kinvey.User.login identity
        .catch (error) ->
          if error.name is 'UserNotFound'
            Kinvey.User.signup identity
          else
            Ember.RSVP.reject error

    logout: ->
      Kinvey.getActiveUser().logout()

`export default ApplicationController`
