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
			@$activityGraph = @$el.find ".activity-graph"
			@ticksCount = 38
			@buttonIndicator = 
				$el: @$el.find ".last-button-icon"
				timeout: null
			Measurements.on "add", @updateGraph, @

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
						value = 4 + (3 / max * value)
					when 'danger'
						value = 7 + (4 / max * value)
					else
						value = (4 / max * value)

				@$activityGraph
					.append(
						$('<li>')
							.addClass(tick.get "tag")
							.append(
								$('<span>')
									.css("height", "#{value}px")
							)
					)