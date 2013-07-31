define ["view/EventDriven-view", "model/DeviceSettings-model", "i18n/i18n"], (EventDrivenView, DeviceSettings, i18n)->
	class MenuItem extends EventDrivenView
		tagName: 'li'
		template: _.template $('#menu-item-template').html()

		initialize:->
			@title = @options.title
			@text = @options.text ? ""
			@checked = false
			@on "menu.item.action", @action
			if @options.settingsValue
				DeviceSettings.on "change:#{@options.settingsValue}", @onValueChange, @
				@onValueChange()

		render:->
			@$el.html @template
				t: i18n.t
				item: @
			@

		onValueChange:->
			if @options.showValue
				@text = DeviceSettings.getValueString @options.settingsValue
			if @options.checkbox
				@checked = DeviceSettings.get(@options.settingsValue) is @options.checkedValue
			@render()

		action: (button)-> 
			if @options.checkbox and @options.settingsValue 
				DeviceSettings.set @options.settingsValue, @options.checkedValue
			
			if @options.screen
				@eventBus.trigger "device.screen.set",
					screenName: @options.screen