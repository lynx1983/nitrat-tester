define [
	"view/EventDriven-view",
	"view/TopPanel-view",
	"view/BottomPanel-view",
	"model/DeviceSettings-model"
	], (EventDrivenView, TopPanel, BottomPanel, DeviceSettings)->
	class DeviceView extends EventDrivenView
		el: $("#device-wrapper")

		events: 
			"click div.button.left": "leftButtonClick"
			"click div.button.center": "centerButtonClick"
			"click div.button.right": "rightButtonClick"
			"click div.button.up": "upButtonClick"
			"click div.button.down": "downButtonClick"
			"click div.cap": "capClick"
			"click div.product": "productClick"
		
		initialize:->
			@topPanel = TopPanel
			@bottomPanel = BottomPanel
			@screens = {}
			@screensStack = []
			@$cap = @$el.find('.cap')
			@$product = @$el.find('.product')
			@eventBus.bind "device.screen.prev", _.bind(@setPrevScreen, @)
			@eventBus.bind "device.screen.set", _.bind(@onScreenSet, @)
			@eventBus.bind "device.cap.open", _.bind(@_openCap, @)
			@eventBus.bind "device.cap.close", _.bind(@_closeCap, @)
			@eventBus.bind "device.product.place", _.bind(@_placeProduct, @)
			@eventBus.bind "device.screen.update", _.bind(@render, @)			
			DeviceSettings.bind 'change:measurementMPC', _.bind(@onMPCChange, @)
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

		_isCapOpened:->
			@$cap.is ".opened"

		_openCap:->
			@$cap.addClass "opened"

		_closeCap:->
			if @_isProductInPlace()
				@_removeProduct()
			@$cap.removeClass "opened"
		
		capClick:-> 
			if not @_isCapOpened() then @_openCap() else @_closeCap()

		_isProductInPlace:->
			@$product.is ".in-place"

		_placeProduct:->
			if not @_isCapOpened()
				@_openCap()
			@$product.addClass "in-place"

		_removeProduct:->
			@$product.removeClass "in-place"

		productClick:->
			if @_isProductInPlace() then @_removeProduct() else @_placeProduct()

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

		onMPCChange:->
			@$product.attr "class", "product " + if @$product.is ".in-place" then "in-place" else ""
			@$product.addClass DeviceSettings.getCurrentMPC().key

	new DeviceView