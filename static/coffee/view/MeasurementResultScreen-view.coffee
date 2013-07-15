define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, i18n)->
	class MeasurementResultScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@tags = [
				'normal',
				'low',
				'medium',
				'danger'
			]
			@lastTag = null

		render: ()->
			@$el.html @template
				t: i18n.t
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
			loop
				tag = @tags[_.random 0, @tags.length - 1]
				break if tag isnt @lastTag
			switch tag
				when 'normal'
					@result = 
						state: Math.round _.random(0, DeviceSettings.getCurrentMPC().mpc) 
						msg: 'Nitrate content are normal'
						tag: tag
				when 'low'
					@result = 
						state: Math.round  _.random(DeviceSettings.getCurrentMPC().mpc, DeviceSettings.getCurrentMPC().mpc * 1.25) 
						msg: 'Slight excess of normal'
						tag: tag
				when 'medium'
					@result = 
						state: Math.round  _.random(DeviceSettings.getCurrentMPC().mpc * 1.25, DeviceSettings.getCurrentMPC().mpc * 1.5) 
						msg: 'Dangerous concentration of nitrates'
						tag: tag
				when 'danger'
					@result = 
						state: Math.round  _.random(DeviceSettings.getCurrentMPC().mpc * 1.5, DeviceSettings.getCurrentMPC().mpc * 2.5) 
						msg: 'Significant excess of normal'
						tag: tag

			@lastTag = tag
