define [
	"view/EventDriven-view"
	], (EventDrivenView)->
		class EnvironmentView extends EventDrivenView
			el: $('.environment')
		
			initialize:->
				@defaultClasses = @$el.attr "class"
				@eventBus.on "environment.set", @setTag, @

			setTag:(tag)->
				@$el.attr "class", @defaultClasses
				@$el.addClass tag if tag

		new EnvironmentView