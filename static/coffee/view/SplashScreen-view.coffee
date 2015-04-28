define ["view/Screen-view"], (ScreenView)->
	class SplashScreen extends ScreenView
		
		constructor: (options)->
			super
			@isFullScreen = true
			@

		initialize:->
			@template = _.template $('#start-screen-template').html()
			
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