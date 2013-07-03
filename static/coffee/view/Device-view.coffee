define ["underscore", "view/EventDriven-view"], (_, EventDrivenView)->
	class DeviceView extends EventDrivenView
		el: $("#device")
		events: 
			"click div.button.left": "leftButtonClick"
			"click div.button.center": "centerButtonClick"
			"click div.button.right": "rightButtonClick"
			"click div.button.up": "upButtonClick"
			"click div.button.down": "downButtonClick"
		
		initialize: ->
			console.log "Device view init."
			@screens = {}
			@screensStack = []

			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.setCurrent", _.bind(@setCurrentScreen, @)
			@

		render: ->
			@

		setPrevScreen: ->
			@screensStack.shift()
			@render()

		setCurrentScreen: ->
			@

		getCurrentScreen: ->
			@screensStack[0] if @screensStack.length > 0

		leftButtonClick: ->
			@buttonClick "button.left.click" if @getCurrentScreen()
		leftButtonClick: ->
			@buttonClick "button.left.click" if @getCurrentScreen()

		buttonClick: (event)->
			@getCurrentScreen().trigger event if @getCurrentScreen()

	new DeviceView