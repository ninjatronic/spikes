`import Ember from 'ember'`
`import LatLng from 'spikes/models/lat-lng'`
`import LatLngBounds from 'spikes/models/lat-lng-bounds'`

# USAGE
#
# {{google-map
#   center: LatLngModel
#   zoom: Number
#   bounds: LatLngBoundsModel
#
#   click: 'click'
#   rightclick: 'rightclick'
# }}

GoogleMapComponent = Ember.Component.extend Ember.Evented,

  classNames: ['map']

  _mapEvents: [
    'bounds_changed'
    'center_changed'
    'dblckick'
    'drag'
    'dragend'
    'dragstart'
    'heading_changed'
    'idle'
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

  _mapActions: [
    'click'
    'rightclick'
  ]

  mapElement: Ember.computed ->
    @$().get 0

  mapOptions: Ember.computed 'center.googleMapsLatLng', 'zoom', ->
    center = @get 'center.googleMapsLatLng'
    center ?= LatLng.create
      lat: 0
      lng: 0

    zoom = @get 'zoom'
    zoom ?= 6

    center: center
    zoom: zoom

  didInsertElement: ->
    @setupMap()
    @setupMapEventListeners()
    @setupMapActionListeners()

    @onMapZoomChanged()
    @onMapCenterChanged()
    @onMapBoundsChanged()

  setupMap: ->
    mapOptions = @get 'mapOptions'
    mapElement = @get 'mapElement'
    @set 'map', new google.maps.Map mapElement, mapOptions

  setupMapEventListener: (mapEvent, listener) ->
    map = @get 'map'
    google.maps.event.addListener map, mapEvent, listener

  setupMapEventListeners: ->
    @get '_mapEvents'
    .forEach (mapEvent) =>
      @setupMapEventListener mapEvent, =>
        @trigger mapEvent.camelize()

  setupMapActionListeners: ->
    @get '_mapActions'
    .forEach (mapAction) =>
      @setupMapEventListener mapAction, (event) =>

        latLng = LatLng.create
          lat: event.latLng.lat()
          lng: event.latLng.lng()

        @sendAction mapAction, latLng

  onMapCenterChanged: Ember.on 'centerChanged', ->
    map = @get 'map'
    mapCenter = map.getCenter()

    center = @get 'center'

    if mapCenter?

      properties =
        lat: mapCenter.lat()
        lng: mapCenter.lng()

      if center?
        center.setProperties properties
      else
        @set 'center', LatLng.create properties

    else

      @set 'center', LatLng.create
        lat: 0
        lng: 0

  onMapZoomChanged: Ember.on 'zoomChanged', ->
    map = @get 'map'
    zoom = map.getZoom()

    @set 'zoom', zoom

  onMapBoundsChanged: Ember.on 'boundsChanged', ->
    map = @get 'map'
    mapBounds = map.getBounds()

    if mapBounds?

      mapSw = mapBounds.getSouthWest()
      mapNe = mapBounds.getNorthEast()

      sw = LatLng.create
        lat: mapSw.lat()
        lng: mapSw.lng()

      ne = LatLng.create
        lat: mapNe.lat()
        lng: mapNe.lng()

      bounds = @get 'bounds'
      properties =
        sw: sw
        ne: ne

      if bounds?
        bounds.setProperties properties
      else
        @set 'bounds', LatLngBounds.create properties

    else

      @set 'bounds', null

  onContextCenterChanged: Ember.observer 'center.googleMapsLatLng', ->
    latLng = @get 'center.googleMapsLatLng'
    @get 'map'
    .setCenter latLng

  onContextZoomChanged: Ember.observer 'zoom', ->
    zoom = @get 'zoom'
    @get 'map'
      .setZoom zoom


`export default GoogleMapComponent`
