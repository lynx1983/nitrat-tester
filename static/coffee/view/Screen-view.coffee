define ["view/EventDriven-view"], (EventDrivenView)->
	class ScreenView extends EventDrivenView
		el: $('#device-wrapper .screen')
		constructor: (options)->
			super
			@name = options.name
			@active = no
			@isFullScreen = no
			@title = options.title ? ""
			@

		activate:->
			console.log "Screen [#{@name}] activate"
			if @options.events?
				for event in @options.events then do (event)=>
					console.log "Bind event [#{event.name}]"
					@eventBus.on event.name, event.callback, @
			@active = yes
			@

		deactivate:->
			console.log "Screen [#{@name}] deactivate"
			if @options.events?
				for event in @options.events then do (event)=>
					console.log "Unbind event [#{event.name}]"
					@eventBus.off event.name, event.callback, @
			@active = no
			@