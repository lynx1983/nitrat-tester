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
		
		initialize: ->
			@screens = {}
			@screensStack = []
			@cap = @$el.find('.cap')
			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.set", _.bind(@onScreenSet, @)
			@$el.find('.screen-wrapper').fadeIn()
			@

		render: ->
			@getCurrentScreen().render() if @getCurrentScreen()
			@

		setPrevScreen: ->
			if @screensStack.length > 1
				@screensStack.shift()
				@render()

		addScreen: (screen)->
			@screens[screen.name] = screen if screen.name
			@

		setCurrentScreen: (screenName)->
			if @screens[screenName] 
				@screensStack.unshift @screens[screenName]
				@render()

		getCurrentScreen: ->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick: ->
			@buttonClick "button.left.click", "left" if @getCurrentScreen()
		
		rightButtonClick: ->
			@buttonClick "button.right.click", "right" if @getCurrentScreen()

		upButtonClick: ->
			@buttonClick "button.up.click", "up" if @getCurrentScreen()
		
		downButtonClick: ->
			@buttonClick "button.down.click", "down" if @getCurrentScreen()

		centerButtonClick: ->
			@buttonClick "button.center.click", "center" if @getCurrentScreen()
		
		buttonClick: (event, button)->
			@getCurrentScreen().trigger event, button if @getCurrentScreen()

		capClick: -> 
			@cap.toggleClass 'opened'

		onScreenSet: (options)->
			if options.screenName?
				if options.screenName == '__prevScreen__'
					@setPrevScreen()
				else
					@setCurrentScreen(options.screenName)


	new DeviceView