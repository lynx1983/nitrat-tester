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
			@eventBus.bind "button.click", _.bind(@showButtonIndicator, @)
			@indicator =
				$el: @$el.find ".indicator"
				position: 1
				direction: 'down'			
			@buttonIndicator = 
				$el: @$el.find ".last-button-icon"
				timeout: null
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

		showButtonIndicator:->
			clearTimeout @buttonIndicator.timeout
			@buttonIndicator.$el.show()
			@buttonIndicator.timeout = setTimeout _.bind(@hideButtonIndicator, @), 1000

		hideButtonIndicator:->
			@buttonIndicator.$el.hide()


	new TopPanelView;
