define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	], (TemplatedScreenView, DeviceSettings)->
	class PreMeasurementScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
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