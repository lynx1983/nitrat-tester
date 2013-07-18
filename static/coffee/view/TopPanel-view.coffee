define [
	"view/Panel-view", 
	"model/DeviceSettings-model"
	"collection/Measurements-collection"
	], (PanelView, DeviceSettings, Measurements)->	
	class TopPanelView extends PanelView
		el: '#device-wrapper .top-panel'
		template: _.template $('#top-panel-template').html()
		initialize: ->
			@$el.html @template
			@listIndicator = @$el.find('.list-indicator')
			@eventBus.bind "list-indicator.set", _.bind(@setListIndicator, @)
			@eventBus.bind "button.click", _.bind(@showButtonIndicator, @)
			@$indicator = @$el.find ".indicator"
			@$activityGraph = @$el.find ".activity-graph"
			@ticksCount = 19
			@buttonIndicator = 
				$el: @$el.find ".last-button-icon"
				timeout: null
			Measurements.on "add", @updateGraph, @
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

		showButtonIndicator:(event)->
			clearTimeout @buttonIndicator.timeout
			@buttonIndicator.$el.attr('class', 'last-button-icon').addClass(event).show()
			@$indicator.css "visibility", "hidden"
			@buttonIndicator.timeout = setTimeout _.bind(@hideButtonIndicator, @), 700

		hideButtonIndicator:->
			@buttonIndicator.$el.hide()
			@$indicator.css "visibility", "visible"

		updateGraph:->
			ticks = Measurements.last(@ticksCount + 1)
			ticks.shift()
			ticks.reverse()
			@$activityGraph.empty()
			_.each ticks, (tick)=>
				value = tick.get "value"
				tag = tick.get "tag"
				max = Measurements.getTagMaxValue tag
				switch tag 
					when 'warning'
						value = 3 + (3 / max * value)
					when 'danger'
						value = 6 + (3 / max * value)
					else
						value = (3 / max * value)

				@$activityGraph
					.append(
						$('<li>')
							.addClass(tick.get "tag")
							.append(
								$('<span>')
									.css("height", "#{value}px")
							)
					)

	new TopPanelView;