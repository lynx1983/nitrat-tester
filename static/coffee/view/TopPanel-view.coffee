define [
	"view/Panel-view", 
	"model/DeviceSettings-model"
	], (PanelView, DeviceSettings)->	
	class TopPanelView extends PanelView
		el: '#device-wrapper .top-panel'
		template: _.template $('#top-panel-template').html()
		initialize: ->
			@$el.html @template
			@listIndicator = @$el.find('.list-indicator')
			@eventBus.bind "list-indicator.set", _.bind(@setListIndicator, @)
			@indicator =
				$el: @$el.find ".indicator"
				position: 1
				direction: 'down'
			@updateTime = setInterval _.bind(@updateActivityIndicator, @), 100

		setListIndicator: (options)->
			@listIndicator
				.removeClass("up")
				.removeClass("down")
				.removeClass("both")
			
			if options?.state?
				@listIndicator.addClass(options.state)

		updateActivityIndicator:->
			if @indicator.direction == 'down'
				@indicator.position += 2
				@indicator.direction = 'up' unless @indicator.position < 10
			else 
				@indicator.position -= 2
				@indicator.direction = 'down' unless @indicator.position > 2
			@indicator.$el.css "top", @indicator.position + 'px'

	new TopPanelView;
