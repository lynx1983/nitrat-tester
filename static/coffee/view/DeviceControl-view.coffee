define [
	"view/EventDriven-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (EventDrivenView, DeviceSettings, i18n)->
		class DeviceControlView extends EventDrivenView
			el: $('.device-control')
		
			initialize:->
				super
				DeviceSettings.on "change", @render, @
				do @loadLangs
				do @render

			events:
				"click .sound": "soundToggle"
				"click .langs li a": "langToggle"

			loadLangs:->
				for code, lang of i18n.languages
					@$(".langs").append $("<li><a href=\"#\" data-lang=\"#{lang.code}\">#{lang.name}</a></li>")

			render:->
				if DeviceSettings.get "soundOn"
					@$(".sound").addClass "on"
				else
					@$(".sound").removeClass "on"

				@$(".lang").attr("class", "lang").addClass DeviceSettings.get "language"

			soundToggle:->
				DeviceSettings.set "soundOn", !DeviceSettings.get "soundOn"
				do @render

			langToggle:(e)->
				do e.preventDefault
				lang = $(e.currentTarget).data "lang"
				DeviceSettings.set "language", lang if lang
				false

		new DeviceControlView