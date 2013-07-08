define ["view/EventDriven-view"], (EventDrivenView)->
	class ScreenView extends EventDrivenView
		el: $('#device-wrapper .screen')
		constructor: (options)->
			@name = options.name
			@active = false
			@title = if options.title then options.title else ''
			EventDrivenView.call @, options
			@

		activate:->
			console.log "Screen [" + @name + "] activate"
			_.each @options.events, (event)->
				console.log "Bind event [" + event.name + "]"
				@eventBus.on event.name, event.callback, @
			, @
			@active = true

		deactivate:->
			console.log "Screen [" + @name + "] deactivate"
			_.each @options.events, (event)->
				console.log "Unbind event [" + event.name + "]"
				@eventBus.off event.name, event.callback, @
			, @
			@active = false