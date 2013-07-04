define ["view/EventDriven-view"], (EventDrivenView)->
	class MenuItem extends EventDrivenView
		constructor: (options)->
			EventDrivenView.call @, options
			@title = options.title

		render: ->
			@$el.html @template
				item: @
			@