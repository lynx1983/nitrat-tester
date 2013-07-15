define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, i18n)->
	class PreMeasurementScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				t: i18n.t
				title: @title
				product: DeviceSettings.getCurrentMPC().name
				mpc: DeviceSettings.getCurrentMPC().mpc
			@

		activate:->
			super
			console.log "Screen [" + @name + "] custom activate"

		deactivate:->
			super			
			console.log "Screen [" + @name + "] custom deactivate"