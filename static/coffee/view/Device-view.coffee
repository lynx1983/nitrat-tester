define [
	"view/EventDriven-view"
	"model/DeviceSettings-model"
	], (EventDrivenView, DeviceSettings)->
	class DeviceView extends EventDrivenView
		el: $("#device-wrapper")

		events: 
			"click div.button.left": "leftButtonClick"
			"click div.button.center": "centerButtonClick"
			"click div.button.right": "rightButtonClick"
			"click div.button.up": "upButtonClick"
			"click div.button.down": "downButtonClick"
			"click div.cap": "capClick"
			"mousedown div.button": "buttonDown"
			"mouseup div.button": "buttonUp"
			"mouseout div.button": "buttonUp"
		
		initialize:->
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

		buttonDown:(e)->
			unless DeviceSettings.isDemoMode()
				$(e.currentTarget).addClass "down"

		buttonUp:(e)->
			$(e.currentTarget).removeClass "down"

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

		start:->
			@setCurrentScreen "start-screen"

		beep:->
			do @beepSound.play if DeviceSettings.get "soundOn"

		getCurrentScreen:->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick:->
			unless DeviceSettings.isDemoMode()
				do @beep
				@eventBus.trigger "button.click", "left"
		
		rightButtonClick:->
			unless DeviceSettings.isDemoMode()
				do @beep
				@eventBus.trigger "button.click", "right"

		upButtonClick:->
			unless DeviceSettings.isDemoMode()
				do @beep
				@eventBus.trigger "button.click", "up"
		
		downButtonClick:->
			unless DeviceSettings.isDemoMode()
				do @beep
				@eventBus.trigger "button.click", "down"

		centerButtonClick:->
			unless DeviceSettings.isDemoMode()
				do @beep
				@eventBus.trigger "button.click", "center"
		
		capClick:->
			unless DeviceSettings.isDemoMode()
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