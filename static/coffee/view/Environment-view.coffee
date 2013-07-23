define [
	"view/EventDriven-view",
	"collection/Measurements-collection",
	"i18n/i18n"
	], (EventDrivenView, MeasurementsCollection, i18n)->
		class EnvironmentView extends EventDrivenView
			el: $('.environment')
			events:
				"click .selector a": "change"
				"click .close": "close"
				"click .open": "open"
			
			initialize:->
				@$selector = @$el.find '.selector'
				@$dialog = @$el.find '.dialog'
				@$link = @$el.find '.open'
				@environments = 
					'normal':
						name: 'Normal'
						caption: 'Fruits'
						levels: [
							probability: .80
							minimum: 100
							maximum: 300
						,
							probability: .17
							minimum: 300
							maximum: 400
						,
							probability: .02
							minimum: 400
							maximum: 1200
						,
							probability: .01
							minimum: 1200
							maximum: 1300
						]
					'increased':
						name: 'Increased'
						caption: 'Building materials'
						levels: [
							probability: .97
							minimum: 400
							maximum: 1200
						,
							probability: .03
							minimum: 1200
							maximum: 1500
						]
					'dangerous':
						name: 'Dangerous'
						caption: 'Toys'
						levels: [
							probability: .90
							minimum: 1300
							maximum: 1400
						,
							probability: .10
							minimum: 1400
							maximum: 1500
						]
				@eventBus.bind "device.screen.update", _.bind(@render, @)
				@render()

			render:->
				@$el.find("a.open").text i18n.t 'Select the measured product'
				@$el.find("h2").text i18n.t 'Select the measured product'
				@$selector.empty()
				_.each @environments, (item, key)->
					@$selector.append(
						$('<li>')
							.addClass(key)
							.html(
								$('<a>')
									.attr('href', '#')
									.attr('data-value', key)
									.text(i18n.t(item.caption))
							)
					)
				, @
				@

			change:(event)->
				MeasurementsCollection.setLevels @environments[$(event.target).data('value')].levels
				@$el.attr 'class', 'environment'
				@$el.addClass $(event.target).data('value')
				@close()
				false

			close:->
				@$link.show()
				@$dialog.hide()
				false

			open:->
				@$link.hide()
				@$dialog.show()
				false

		new EnvironmentView