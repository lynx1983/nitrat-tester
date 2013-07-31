define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	"collection/Measurements-collection"
	], (TemplatedScreenView, DeviceSettings, i18n, Measurements)->
	class MeasurementResultScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@result = 
				e: {}
				m: {}

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
			eAvgValue = Math.sqrt((Math.pow(eValue.x, 2) + Math.pow(eValue.y, 2)) / 2)
			mAvgValue = Math.sqrt((Math.pow(mValue.x, 2) + Math.pow(mValue.y, 2) + Math.pow(mValue.z, 2)) / 3)
			@result =
				e:
					x: eValue.x
					xNorm: 100 * (eValue.x / @options.electricMax)
					y: eValue.y
					yNorm: 100 * (eValue.y / @options.electricMax)
					level: @options.electricLevel / 1000
					value: eAvgValue.toFixed(2)
					msg: if eAvgValue > @options.electricLevel then "Превышение нормы электричес<br/>кого поля" else "Electric field in normal"
					tag: if eAvgValue > @options.electricLevel then "high" else "normal"
				m:
					x: mValue.x
					xNorm: 100 * (mValue.x / @options.magneticMax)
					y: mValue.y
					yNorm: 100 * (mValue.y / @options.magneticMax)
					z: mValue.z
					zNorm: 100 * (mValue.z / @options.magneticMax)
					level: @options.magneticLevel
					value: mAvgValue.toFixed(2)
					msg: if mAvgValue > @options.magneticLevel then "Excess norm magnetic field" else "Magnetic field in normal"
					tag: if mAvgValue > @options.magneticLevel then "high" else "normal"