define ["view/Screen-view"], (ScreenView)->
	class TemplatedScreenView extends ScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()
			@on "button.left.click", @onLeftButton

		render: ()->
			@$el.html @template
				title: @title
			@

		onLeftButton: ->
			@eventBus.trigger "device.screen.prev"