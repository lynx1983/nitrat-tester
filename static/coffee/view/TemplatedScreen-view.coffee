define ["view/Screen-view"], (ScreenView)->
	class TemplatedScreenView extends ScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				title: @title
			@