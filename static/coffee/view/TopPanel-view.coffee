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
			@$indicator = @$el.find ".indicator"
			@buttonIndicator = 
				$el: @$el.find ".last-button-icon"
				timeout: null
			@updateTime = setInterval _.bind(@updateActivityIndicator, @), 300

		setListIndicator: (options)->
			@listIndicator
				.removeClass("up")
				.removeClass("down")
				.removeClass("both")
			
			if options?.state?
				@listIndicator.addClass(options.state)

		updateActivityIndicator:->
			@$indicator.toggleClass "down"

		showButtonIndicator:->
			clearTimeout @buttonIndicator.timeout
			@buttonIndicator.$el.show()
			@buttonIndicator.timeout = setTimeout _.bind(@hideButtonIndicator, @), 1000

		hideButtonIndicator:->
			@buttonIndicator.$el.hide()


	new TopPanelView;
