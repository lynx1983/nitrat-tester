define ["view/TemplatedScreen-view"], (TemplatedScreenView)->
	class CalibrationScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@timeOut = null
			@direction = if @options.direction == 'down' then 'down' else 'up'
			@render()

		render: ()->
			@$el.html @template
				title: @title
			@

		activate:->
			super
			console.log "Screen [" + @name + "] custom activate"
			@position = if @direction == 'up' then 0 else 100	
			@timeOut = setTimeout _.bind(@update, @), 500

		deactivate:->
			super			
			console.log "Screen [" + @name + "] custom deactivate"
			clearTimeout @timeOut

		update: ->
			@position = if @direction == 'up' then @position + 10 else @position - 10
			if @position <= 100 and @position >= 0
				@$el.find('.graph .indicator').css "width", @position + '%'
				@timeOut = setTimeout _.bind(@update, @), 500
			else
				if @options.nextScreen
					@eventBus.trigger "device.screen.set",
						screenName: @options.nextScreen