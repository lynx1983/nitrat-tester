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
			@topPanel = TopPanel
			@bottomPanel = BottomPanel
			@screens = {}
			@screensStack = []
			@cap = @$el.find('.cap')
			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.set", _.bind(@onScreenSet, @)
			@eventBus.bind "device.screen.update", _.bind(@render, @)
			@$el.find('.screen-wrapper').fadeIn()
			@beepSound =@$el.find('audio').get 0
			@

		render:->
			@topPanel.render()
			@getCurrentScreen().render() if @getCurrentScreen()
			@bottomPanel.render()
			@

		setPrevScreen:->
			if @screensStack.length > 1
				@getCurrentScreen()?.deactivate()
				@screensStack.shift()
				@getCurrentScreen()?.activate()
				@render()

		addScreen:(screen)->
			@screens[screen.name] = screen if screen.name
			@

		setCurrentScreen: (screenName)->
			if @screens[screenName] 
				@getCurrentScreen()?.deactivate()
				if @getCurrentScreen()?.options.noTrackScreen 
					@screensStack.shift()
				@screensStack.unshift @screens[screenName]
				@setFullScreen @getCurrentScreen().isFullScreen
				@getCurrentScreen().activate()
				@render()

		beep:->
			@beepSound.play()

		getCurrentScreen:->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick:->
			@beep()
			@eventBus.trigger "button.click", "left"
		
		rightButtonClick:->
			@beep()
			@eventBus.trigger "button.click", "right"

		upButtonClick:->
			@beep()
			@eventBus.trigger "button.click", "up"
		
		downButtonClick:->
			@beep()
			@eventBus.trigger "button.click", "down"

		centerButtonClick:->
			@beep()
			@eventBus.trigger "button.click", "center"
		
		capClick:-> 
			@cap.toggleClass 'opened'

		setFullScreen:(flag)->
			if flag 
				@$el.find('.screen-wrapper').addClass "fullscreen" 
			else
				@$el.find('.screen-wrapper').removeClass "fullscreen"

		isFullScreen:->
			@$el.find('.screen-wrapper').is(".fullscreen")

		onScreenSet:(options)->
			if options.screenName?
				if options.screenName == '__prevScreen__'
					@setPrevScreen()
				else
					@setCurrentScreen(options.screenName)


	new DeviceView