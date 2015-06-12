define ["view/EventDriven-view", "model/DeviceSettings-model", "i18n/i18n"], (EventDrivenView, DeviceSettings, i18n)->
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
				t: i18n.t
				item: @
			@$el.addClass @options.align if @options.align?
			@$el.addClass @options.class if @options.class?
			@

		onValueChange: ->
			if @options.showValue
				if @options.showSettingsValue
					@text = DeviceSettings.getValueString @options.showSettingsValue
				else
					@text = DeviceSettings.getValueString @options.settingsValue
			if @options.checkbox
				@checked = DeviceSettings.get(@options.settingsValue) == @options.checkedValue
			do @render

		action: (button)-> 
			if @options.checkbox and @options.settingsValue 
				DeviceSettings.set(@options.settingsValue, @options.checkedValue)			
			
			if @options.screen
				@eventBus.trigger "device.screen.set",
					screenName: @options.screen

			if @options.back 
				@eventBus.trigger "device.screen.prev"

			if _.isFunction @options.action
				@options.action.apply @, arguments