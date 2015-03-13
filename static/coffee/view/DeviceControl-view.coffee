define [
	"view/EventDriven-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (EventDrivenView, DeviceSettings, i18n)->
		class DeviceControlView extends EventDrivenView
			el: $('.device-control')
		
			initialize:->
				super
				do @render

			events:
				"click .sound": "soundToggle"

			render:->
				if DeviceSettings.get "soundOn"
					@$(".sound").text i18n.t "Mute"
				else
					@$(".sound").text i18n.t "Unmute"

				@$(".demo").text i18n.t "Demo"
				@$(".lang").text i18n.t "Lang"
				@$(".share").text i18n.t "Share"

			soundToggle:->
				DeviceSettings.set "soundOn", !DeviceSettings.get "soundOn"
				do @render

		new DeviceControlView