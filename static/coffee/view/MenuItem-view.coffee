define ["view/EventDriven-view", "model/DeviceSettings-model"], (EventDrivenView, DeviceSettings)->
	class MenuItem extends EventDrivenView
		tagName: 'li'
		template: _.template $('#menu-item-template').html()

		initialize: ->
			@title = @options.title
			@text = @options.text if @options.text
			@checked = false
			@on "menu.item.action", @action
			if @options.settingsValue
				DeviceSettings.bind 'change:' + @options.settingsValue, _.bind(@onValueChange, @)
				@onValueChange()

		render: ->
			@$el.html @template
				item: @
			@

		onValueChange: ->
			if @options.showValue
				@text = DeviceSettings.getValueString @options.settingsValue
			if @options.checkbox
				@checked = DeviceSettings.get(@options.settingsValue) == @options.checkedValue
			@render()

		action: (button)-> 
			if @options.screen and button == "right"
				@eventBus.trigger "device.screen.set",
					screenName: @options.screen

			if @options.checkbox and @options.settingsValue and button == "center"
				DeviceSettings.set(@options.settingsValue, @options.checkedValue)