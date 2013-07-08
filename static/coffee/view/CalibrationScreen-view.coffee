define ["view/TemplatedScreen-view"], (TemplatedScreenView)->
	class CalibrationScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@position = 0
			@timeOut = null;

		render: ()->
			@$el.html @template
				title: @title
			@

		activate:->
			super
			console.log "Screen [" + @name + "] custom activate"
			@position = 0		
			@$el.find('.graph .indicator').css "width", 0	
			@timeOut = setTimeout _.bind(@update, @), 500

		deactivate:->
			super			
			console.log "Screen [" + @name + "] custom deactivate"
			clearTimeout @timeOut

		update: ->
			@position += 10
			if @position <= 100 
				@$el.find('.graph .indicator').css "width", @position + '%'
				@timeOut = setTimeout _.bind(@update, @), 500
			else
				@eventBus.trigger "device.screen.set",
					screenName: 'pre-measurement-screen'