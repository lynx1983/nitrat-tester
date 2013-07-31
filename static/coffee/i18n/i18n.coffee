define ["underi18n", "model/DeviceSettings-model", "event/EventBus-event", "./lang/ru"], (underi18n, DeviceSettings, EventBus, ru)->
	class i18n
		constructor:->
			DeviceSettings.bind 'change:language', _.bind(@onLangChange, @)
			@t = underi18n.MessageFactory({})
			@eventBus = EventBus
			@languages =
				'en': {}
				'ru': ru

		onLangChange:(model, lang)->
			console.log "Language changed to '#{lang}'"
			if @languages[lang]
				@t = underi18n.MessageFactory @languages[lang]
				@eventBus.trigger "device.screen.update"

		t:()->

	new i18n