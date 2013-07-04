define ["underscore", "view/EventDriven-view"], (_, EventDrivenView)->
	class ScreenView extends EventDrivenView
		el: $('#device-wrapper .screen')
		constructor: (options)->
			@name = options.name
			@title = if options.title then options.title else ''
			EventDrivenView.call @, options
			@