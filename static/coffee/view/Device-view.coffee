define ["view/EventDriven-view", "view/TopPanel-view", "view/BottomPanel-view", "i18n/i18n"], (EventDrivenView, TopPanel, BottomPanel, i18n)->
	class DeviceView extends EventDrivenView
		el: $("#device-wrapper")

		events: 
			"click div.button.left": "leftButtonClick"
			"click div.button.center": "centerButtonClick"
			"click div.button.right": "rightButtonClick"
		
		initialize:->
			@msgTemplate = _.template $("#screen-message-template").html()
			@topPanel = TopPanel
			@bottomPanel = BottomPanel
			@messageShowing = false
			@$msg = null
			@screens = {}
			@screensStack = []
			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.set", _.bind(@onScreenSet, @)
			@eventBus.bind "device.screen.update", _.bind(@render, @)
			@eventBus.on "device.screen.msg", @showMessage, @
			@eventBus.bind "device.beep", _.bind(@beep, @)
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

		resetScreens:->
			if @screensStack.length > 1
				@getCurrentScreen()?.deactivate()
				while @screensStack.length > 1
					@screensStack.shift()
				@getCurrentScreen()?.activate()
				@render()

		beep:->
			@beepSound.play()

		getCurrentScreen:->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick:->
			do @beep
			if @messageShowing 
				do @hideMessage
			else
				@eventBus.trigger "button.click", "left"
		
		rightButtonClick:->
			do @beep
			if @messageShowing 
				do @hideMessage
			else
				@eventBus.trigger "button.click", "right"

		centerButtonClick:->
			do @beep
			if @messageShowing 
				do @hideMessage
			else
				@eventBus.trigger "button.click", "center"
				do @resetScreens
		
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

		showMessage:(options)->
			console.log "Show message"
			@$msg = @msgTemplate
				t: i18n.t
				text: options?.text or ""

			@$el.find(".screen-wrapper").append @$msg
			@messageShowing = true

		hideMessage:->
			console.log "Hide message"
			@$el.find(".message-wrapper").remove()
			@$msg = null
			@messageShowing = false


	new DeviceView