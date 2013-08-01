define [
	"view/Panel-view", 
	"model/DeviceSettings-model"
	], (PanelView, DeviceSettings)->	
	class TopPanelView extends PanelView
		el: '#device-wrapper .top-panel'
		template: _.template $('#top-panel-template').html()
		initialize: ->
			@$el.html @template
			@listIndicator = @$el.find ".list-indicator"
			@eventBus.on "list-indicator.set", @setListIndicator, @
			@eventBus.on "button.click", @showButtonIndicator, @
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
			
			@listIndicator.addClass(options.state) if options?.state?

		updateActivityIndicator:->
			@$indicator.toggleClass "down"

		showButtonIndicator:(event)->
			clearTimeout @buttonIndicator.timeout
			@buttonIndicator.$el.attr('class', 'last-button-icon').addClass(event).show()
			@$indicator.css "visibility", "hidden"
			@buttonIndicator.timeout = setTimeout _.bind(@hideButtonIndicator, @), 700

		hideButtonIndicator:->
			@buttonIndicator.$el.hide()
			@$indicator.css "visibility", "visible"


	new TopPanelView;
