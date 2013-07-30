define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, i18n)->
	class MeasurementResultScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				t: i18n.t
				title: @title
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			@eventBus.trigger "soft-button.setText", "left", ""
			@eventBus.trigger "soft-button.setText", "center", "menu"
			@eventBus.trigger "soft-button.setText", "right", "next"
			@updateInterval = setInterval _.bind(@update, @), 1000

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"
			clearInterval @updateInterval

		measurement:->
			console.log "Do measurement"

		update:->
			console.log "Update screen"
