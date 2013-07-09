define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	], (TemplatedScreenView, DeviceSettings)->
	class MeasurementResultScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@tags = [
				'normal',
				'low',
				'medium',
				'danger'
			]

		render: ()->
			@$el.html @template
				title: @title
				result: @result
			@

		activate:->
			super
			console.log "Screen [" + @name + "] custom activate"
			@measurement()

		deactivate:->
			super			
			console.log "Screen [" + @name + "] custom deactivate"

		measurement:->
			tag = @tags[_.random 0, @tags.length - 1]
			switch tag
				when 'normal'
					@result = 
						state: _.random(0, DeviceSettings.getCurrentMPC().mpc) 
						msg: 'Содержание нитратов в норме'
						tag: tag
				when 'low'
					@result = 
						state: _.random(DeviceSettings.getCurrentMPC().mpc, DeviceSettings.getCurrentMPC().mpc * 1.25) 
						msg: 'Незначительное превышение нормы'
						tag: tag
				when 'medium'
					@result = 
						state: _.random(DeviceSettings.getCurrentMPC().mpc * 1.25, DeviceSettings.getCurrentMPC().mpc * 1.5) 
						msg: 'Опасная концентрация нитратов'
						tag: tag
				when 'danger'
					@result = 
						state: _.random(DeviceSettings.getCurrentMPC().mpc * 1.5, DeviceSettings.getCurrentMPC().mpc * 2.5) 
						msg: 'Значительное превышение нормы'
						tag: tag
