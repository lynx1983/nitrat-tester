define ["view/Panel-view", "model/DeviceSettings-model"], (PanelView, DeviceSettings)->	
	class TopPanelView extends PanelView
		el: '#device-wrapper .top-panel'
		template: _.template $('#top-panel-template').html()
		initialize: ->
			@$el.html @template
			@listIndicator = @$el.find('.list-indicator')
			@eventBus.bind "list-indicator.set", _.bind(@setListIndicator, @)

		setListIndicator: (state)->
			@listIndicator
				.removeClass("up")
				.removeClass("down")
				.removeClass("both")
				.addClass(state)


	new TopPanelView;
