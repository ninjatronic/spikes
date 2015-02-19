`import Ember from 'ember'`


GooglePlusService = Ember.Object.extend

  login: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      gapi.auth.signIn
        'callback': (response) ->
          console.log response
          if response.error?
            if response.error isnt 'immediate_failed'
              reject response.error
          else
            resolve response


`export default GooglePlusService`
