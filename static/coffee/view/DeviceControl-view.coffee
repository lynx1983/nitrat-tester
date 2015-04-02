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
				do @render

			events:
				"click .sound": "soundToggle"
				"click .lang": "langToggle"

			render:->
				if DeviceSettings.get "soundOn"
					@$(".sound").text i18n.t "Mute"
				else
					@$(".sound").text i18n.t "Unmute"

				#@$(".lang").text i18n.getLanguageName DeviceSettings.get "language"

				@$(".demo").text i18n.t "Demo"
				@$(".share").text i18n.t "Share"

			soundToggle:->
				DeviceSettings.set "soundOn", !DeviceSettings.get "soundOn"
				do @render

			langToggle:(e)->
				lang = $(e.currentTarget).data "lang"
				DeviceSettings.set "language", lang if lang

		new DeviceControlView