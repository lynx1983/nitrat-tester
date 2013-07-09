define ["backbone", "event/EventBus-event"], (Backbone, EventBus) ->
	class EventDrivenView extends Backbone.View
		constructor: (options)->
			@eventBus = (options && options.eventBus) || EventBus
			super