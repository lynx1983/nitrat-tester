define ["underi18n", "model/DeviceSettings-model", "event/EventBus-event", "./lang/ru"], (underi18n, DeviceSettings, EventBus, ru)->
	class i18n
		constructor:->
			DeviceSettings.on 'change:language', @onLanguageChange, @
			@t = underi18n.MessageFactory {}
			@eventBus = EventBus
			@languages =
				en:
					code: 'en'
					name: 'English'
				ru:
					code: 'ru'
					name: 'Русский'

		getLanguageName:(lang)->
			@languages[lang].name if @languages[lang]

		onLanguageChange:(model, lang)->
			console.log "Language changed to '#{lang}'"
			if @languages[lang]
				@t = underi18n.MessageFactory @languages[lang].code
				@eventBus.trigger "device.screen.update"

		t:->

	new i18n