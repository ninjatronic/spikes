`import Ember from 'ember'`
`import { initialize } from '../../../initializers/kinvey'`
`import { module, test } from 'qunit'`

container = null
application = null

module 'KinveyInitializer',
  beforeEach: ->
    Ember.run ->
      application = Ember.Application.create()
      container = application.__container__
      application.deferReadiness()

# Replace this with your real tests.
test 'it works', (assert) ->
  initialize container, application

  # you would normally confirm the results of the initializer here
  assert.ok true
