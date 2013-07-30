define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	"collection/Measurements-collection"
	], (TemplatedScreenView, DeviceSettings, i18n, Measurements)->
	class MeasurementResultScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				t: i18n.t
				title: @title
				result: @result
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			@eventBus.trigger "soft-button.setText", "left", ""
			@eventBus.trigger "soft-button.setText", "center", "menu"
			@eventBus.trigger "soft-button.setText", "right", "next"
			Measurements.on "add", @updateView, @

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"
			Measurements.off "add", @updateView, @

		updateView:(measure)->
			@update measure
			@render()

		update:(measure)->
			console.log "Update screen"
			eValue = measure.get "e"
			mValue = measure.get "m"
			@result =
				e:
					level: @options.electricLevel / 1000
					value: Math.sqrt((Math.pow(eValue.x, 2) + Math.pow(eValue.y, 2)) / 2).toFixed(2)
					msg: if true then "Electric field in normal" else ""
				m:
					level: @options.magneticLevel
					value: Math.sqrt((Math.pow(mValue.x, 2) + Math.pow(mValue.y, 2) + Math.pow(mValue.z, 2)) / 3).toFixed(2)
					msg: if true then "Magnetic field in normal" else ""