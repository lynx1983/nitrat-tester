define ["underscore", "view/EventDriven-view"], (_, EventDrivenView)->
	class ScreenView extends EventDrivenView
		initialize: ->
			@name = @options.name

		render: ->
			@