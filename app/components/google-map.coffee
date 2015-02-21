`import Ember from 'ember'`
`import LatLng from 'spikes/models/lat-lng'`
`import LatLngBounds from 'spikes/models/lat-lng-bounds'`

# USAGE
#
# {{google-map
#   center: LatLngModel
#   zoom: Number
#   bounds: LatLngBoundsModel
#   markers: [MarkerModel]
#
#   click: 'click'
#   rightclick: 'rightclick'
# }}

GoogleMapComponent = Ember.Component.extend Ember.Evented,

  # map event names to use with trigger
  _mapEvents: [
    'bounds_changed'
    'center_changed'
    'dblckick'
    'drag'
    'dragend'
    'dragstart'
    'heading_changed'
    'maptypeid_changed'
    'mousemove'
    'mouseout'
    'mouseover'
    'projection_changed'
    'resize'
    'tilesloaded'
    'tilt_changed'
    'zoom_changed'
  ]

  # map event names to use with sendAction
  _mapActions: [
    'click'
    'rightclick'
    'idle'
  ]

  # compute the dom element for the map
  _mapElement: Ember.computed ->
    @$().get 0

  #
  # compute the map center from the 'center' property and keep the map updated
  #

  _contextCenter: Ember.computed.alias 'center'
  _defaultCenter: LatLng.create
    lat: 0
    lng: 0

  _contextCenterLatLng: Ember.computed.alias '_contextCenter.googleMapsLatLng'
  _defaultCenterLatLng: Ember.computed.alias '_defaultCenter.googleMapsLatLng'

  _centerLatLng: Ember.computed \
    '_contextCenterLatLng', '_defaultCenterLatLng', ->
      contextCenterLatLng = @get '_contextCenterLatLng'
      defaultCenterLatLng = @get '_defaultCenterLatLng'
      return contextCenterLatLng or defaultCenterLatLng

  _updateMapOnCenterLatLngChange: Ember.observer '_centerLatLng', ->
    @get 'map'
    ?.setCenter @get '_centerLatLng'

  #
  # compute the context center from the map center after a change
  #

  _updateContextOnMapCenterChanged: Ember.on 'centerChanged', ->
    map = @get 'map'
    mapCenter = map?.getCenter()
    contextCenter = @get '_contextCenter'

    if mapCenter?

      if contextCenter?
        contextCenter.setPropertiesFromGoogleMapsLatLng mapCenter
      else
        @set '_contextCenter', LatLng.create mapCenter

    else

      @set '_contextCenter', LatLng.create
        lat: 0
        lng: 0

  #
  # compute the map zoom from the 'zoom' property and keep the map updated
  #

  _defaultZoom: 6
  _contextZoom: Ember.computed.alias 'zoom'

  _zoom: Ember.computed '_contextZoom', '_defaultZoom', ->
    contextZoom = @get '_contextZoom'
    defaultZoom = @get '_defaultZoom'

    if contextZoom?
      return contextZoom
    else
      return defaultZoom

  _updateMapOnZoomChange: Ember.observer '_zoom', ->
    @get 'map'
    ?.setZoom @get '_zoom'

  #
  # compute the context center from the map center after a change
  #

  _updateContextOnMapZoomChanged: Ember.on 'zoomChanged', ->
    map = @get 'map'
    zoom = map?.getZoom()

    @set '_contextZoom', zoom

  # compute the map options object
  _mapOptions: Ember.computed '_centerLatLng', '_zoom', ->
    center = @get '_centerLatLng'
    zoom = @get '_zoom'

    options =
      center: center
      zoom: zoom

    return options

  #
  # compute the context bounds from the map bounds after a change
  #

  _updateContextOnMapBoundsChanged: Ember.on 'boundsChanged', ->
    map = @get 'map'
    mapBounds = map?.getBounds()

    if mapBounds?

      bounds = @get 'bounds'
      if bounds?
        bounds.setPropertiesFromGoogleMapsLatLngBounds mapBounds
      else
        @set 'bounds', LatLngBounds.create mapBounds

    else

      @set 'bounds', null
  #
  # setup the component
  # * create the map
  # * setup map event listeners that call trigger
  # * setup map event listeners that call sendAction
  # * simulate property change events on the map
  #

  _setup: ->
    @_setupMap()
    @_setupMapEventListeners()
    @_setupMapActionListeners()

    @_updateContextOnMapZoomChanged()
    @_updateContextOnMapCenterChanged()
    @_updateContextOnMapBoundsChanged()

  _setupMap: ->
    mapOptions = @get '_mapOptions'
    mapElement = @get '_mapElement'
    @set 'map', new google.maps.Map mapElement, mapOptions

  _setupMapEventListener: (mapEvent, listener) ->
    map = @get 'map'
    google.maps.event.addListener map, mapEvent, listener

  _setupMapEventListeners: ->
    @get '_mapEvents'
    .forEach (mapEvent) =>
      @_setupMapEventListener mapEvent, =>
        @trigger mapEvent.camelize()

  _setupMapActionListeners: ->
    @get '_mapActions'
    .forEach (mapAction) =>
      @_setupMapEventListener mapAction, (event) =>
        @sendAction mapAction.camelize(), \
          if event? then LatLng.create event.latLng

  #
  # when the component element is inserted call the setup method
  #

  didInsertElement: ->
    @_setup()

  #
  # observe the context markers and propagate changes to the map
  #

  _contextMarkers: Ember.computed.alias 'markers'

  _setupContextMarkersOnInit: Ember.on 'init', ->
    @_setupContextMarkersEnumerableObserver()
    @_addContextMarkersToMap @get '_contextMarkers'

  _setupContextMarkersOnChanged: Ember.observer '_contextMarkers', ->
    @_setupContextMarkersEnumerableObserver()
    @_addContextMarkersToMap @get '_contextMarkers'

  _teardownContextMarkersBeforeChange: \
    Ember.beforeObserver '_contextMarkers', ->
      contextMarkers = @get '_contextMarkers'
      @_teardownContextMarkersEnumerableObserver()
      @_removeContextMarkersFromMap contextMarkers, contextMarkers, 0

  _contextMarkersEnumerableObserver: ->
    willChange: (contextMarkers, removingItems) =>
      @_removeContextMarkersFromMap removingItems
    didChange: (contextMarkers, removedCount, addedItems) =>
      @_addContextMarkersToMap addedItems

  _removeContextMarkersFromMap: (markersToRemove) ->
    markersToRemove?.forEach (marker) ->
      marker.set 'map', null

  _addContextMarkersToMap: (markersToAdd) ->
    markersToAdd?.forEach (marker) =>
      marker.set 'map', @get 'map'

  _setupContextMarkersEnumerableObserver: ->
    contextMarkers = @get '_contextMarkers'
    contextMarkersEnumerableObserver = @get 'contextMarkersEnumerableObserver'
    contextMarkers?.addEnumerableObserver this, contextMarkersEnumerableObserver

  _teardownContextMarkersEnumerableObserver: \
    Ember.beforeObserver '_contextMarkers', ->
      contextMarkers = @get '_contextMarkers'
      contextMarkersEnumerableObserver = @get 'contextMarkersEnumerableObserver'
      contextMarkers?.removeEnumerableObserver \
        this, contextMarkersEnumerableObserver

  #
  # observe the map and teardown/setup the context markers when it changes
  #

  _teardownMarkersBeforeMapChange: Ember.beforeObserver 'map', ->
    @get 'markers'
    ?.forEach (marker) ->
      marker.set 'map', null

  _setupMarkersOnMapChanged: Ember.observer 'map', ->
    @get 'markers'
    ?.forEach (marker) =>
      marker.set 'map', @get 'map'


`export default GoogleMapComponent`
