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
			@cap = @$el.find ".cap"
			@eventBus.on "device.screen.prev", @setPrevScreen, @
			@eventBus.on "device.screen.set", @onScreenSet, @
			@eventBus.on "device.screen.update", @render, @
			@eventBus.on "device.beep", @beep, @
			@$el.find('.screen-wrapper').fadeIn()
			@beepSound = @$el.find('audio').get 0
			@

		render:->
			do @topPanel.render
			do @getCurrentScreen().render if @getCurrentScreen()
			do @bottomPanel.render
			@

		setPrevScreen:->
			if @screensStack.length > 1
				@getCurrentScreen()?.deactivate()
				do @screensStack.shift
				@getCurrentScreen()?.activate()
				do @render
			@

		addScreen:(screen)->
			@screens[screen.name] = screen if screen.name
			@

		setCurrentScreen: (screenName)->
			if @screens[screenName] 
				@getCurrentScreen()?.deactivate()
				if @getCurrentScreen()?.options.noTrackScreen 
					do @screensStack.shift
				@screensStack.unshift @screens[screenName]
				@setFullScreen @getCurrentScreen().isFullScreen
				@getCurrentScreen().activate()
				do @render
			@

		beep:->
			do @beepSound.play

		getCurrentScreen:->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick:->
			do @beep
			@eventBus.trigger "button.click", "left"
		
		rightButtonClick:->
			do @beep
			@eventBus.trigger "button.click", "right"

		upButtonClick:->
			do @beep
			@eventBus.trigger "button.click", "up"
		
		downButtonClick:->
			do @beep
			@eventBus.trigger "button.click", "down"

		centerButtonClick:->
			do @beep
			@eventBus.trigger "button.click", "center"
		
		capClick:-> 
			@cap.toggleClass 'opened'

		setFullScreen:(flag)->
			if flag 
				@$el.find('.screen-wrapper').addClass "fullscreen" 
			else
				@$el.find('.screen-wrapper').removeClass "fullscreen"
			@

		isFullScreen:->
			@$el.find('.screen-wrapper').is ".fullscreen"

		onScreenSet:(options)->
			if options?.screenName?
				if options.screenName is '__prevScreen__'
					@setPrevScreen()
				else
					@setCurrentScreen options.screenName

	new DeviceView