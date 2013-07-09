define ["view/EventDriven-view", "view/TopPanel-view", "view/BottomPanel-view"], (EventDrivenView, TopPanel, BottomPanel)->
	class DeviceView extends EventDrivenView
		el: $("#device-wrapper")

		events: 
			"click div.button.left": "leftButtonClick"
			"click div.button.center": "centerButtonClick"
			"click div.button.right": "rightButtonClick"
			"click div.button.up": "upButtonClick"
			"click div.button.down": "downButtonClick"
			"click div.cap": "capClick"
		
		initialize:->
			@screens = {}
			@screensStack = []
			@cap = @$el.find('.cap')
			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.set", _.bind(@onScreenSet, @)
			@$el.find('.screen-wrapper').fadeIn()
			@

		render:->
			@getCurrentScreen().render() if @getCurrentScreen()
			@

		setPrevScreen:->
			if @screensStack.length > 1
				@getCurrentScreen().deactivate() if @getCurrentScreen()
				@screensStack.shift()
				while @getCurrentScreen().options.noTrack? == true
					@screensStack.shift()
				@getCurrentScreen().activate()
				@render()

		addScreen:(screen)->
			@screens[screen.name] = screen if screen.name
			@

		setCurrentScreen: (screenName)->
			if @screens[screenName] 
				@getCurrentScreen().deactivate() if @getCurrentScreen()
				@screensStack.unshift @screens[screenName]
				@getCurrentScreen().activate()
				@render()

		getCurrentScreen:->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick:->
			@eventBus.trigger "button.click", "left"
		
		rightButtonClick:->
			@eventBus.trigger "button.click", "right"

		upButtonClick:->
			@eventBus.trigger "button.click", "up"
		
		downButtonClick:->
			@eventBus.trigger "button.click", "down"

		centerButtonClick:->
			@eventBus.trigger "button.click", "center"
		
		capClick:-> 
			@cap.toggleClass 'opened'

		onScreenSet: (options)->
			if options.screenName?
				if options.screenName == '__prevScreen__'
					@setPrevScreen()
				else
					@setCurrentScreen(options.screenName)


	new DeviceView