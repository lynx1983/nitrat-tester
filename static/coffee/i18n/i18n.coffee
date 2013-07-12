define ["underi18n", "model/DeviceSettings-model", "./lang/ru"], (underi18n, DeviceSettings, ru)->
	class i18n
		constructor:()->
			DeviceSettings.bind 'change:language', _.bind(@onLangChange, @)
			@t = underi18n.MessageFactory({})
			@languages =
				'en': {}
				'ru': ru

		onLangChange:(model, lang)->
			console.log "Language changed"
			@t = underi18n.MessageFactory @languages[lang] if @languages[lang]

		t:()->

	new i18n