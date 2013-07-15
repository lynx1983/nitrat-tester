define ["view/Screen-view", "i18n/i18n"], (ScreenView, i18n)->
	class TemplatedScreenView extends ScreenView
		initialize: ()->
			@template = _.template $(@options.template).html()

		render: ()->
			@$el.html @template
				t: i18n.t
				title: @title
			@