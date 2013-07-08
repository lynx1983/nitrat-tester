define ["view/TemplatedScreen-view"], (TemplatedScreenView)->
	class CalibrationScreenView extends TemplatedScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				title: @title
			@