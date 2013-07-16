define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, i18n)->
	class MeasurementScreenView extends TemplatedScreenView
		initialize:->
			@template = _.template $(@options.template).html()
			@tag = ''

		render:->
			@$el.html @template
				t: i18n.t
				title: @title
				unit: if DeviceSettings.get("unit") is "sievert" then "mcSv/h" else "mcR/h"
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"