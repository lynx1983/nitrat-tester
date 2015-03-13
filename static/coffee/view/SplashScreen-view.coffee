define ["view/Screen-view"], (ScreenView)->
	class SplashScreen extends ScreenView
		template: _.template $('#start-screen-template').html()
		constructor: (options)->
			super
			@isFullScreen = true
			@
			
		render:->
			@$el.html @template
			@$el.find('.view')
				.css('opacity', 0)
				.animate
					opacity: 1
					, 1000
				.delay(2000)
				.animate
					opacity: 0
					, 1000
					, _.bind ->
						@eventBus.trigger "device.screen.set",
							screenName: @options.nextScreen
					, @