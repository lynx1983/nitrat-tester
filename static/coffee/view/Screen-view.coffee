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
			@active = true

		deactivate:->
			console.log "Screen [" + @name + "] deactivate"
			@active = false