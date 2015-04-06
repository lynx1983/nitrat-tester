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
				@$(".content input").val "<iframe src=\"#{location.href}\"></iframe>"
				do @loadLangs
				do @render

			events:
				"click .sound": "soundToggle"
				"click .lang": "toggleLang"
				"click .langs li a": "langToggle"
				"click .demo": "demoToggle"
				"click .share": "shareToggle"

			loadLangs:->
				for code, lang of i18n.languages
					@$(".langs").append $("<li><a href=\"#\" class=\"flag #{lang.code}\" data-lang=\"#{lang.code}\"></a></li>")

			render:->
				if not DeviceSettings.get "soundOn"
					@$(".sound").addClass "on"
				else
					@$(".sound").removeClass "on"

				if DeviceSettings.get "demoMode"
					@$(".demo").addClass "on"
				else
					@$(".demo").removeClass "on"

				@$(".content .copyright").text i18n.t "COPYRIGHT"

				@$(".lang").attr("class", "lang").addClass DeviceSettings.get "language"
				@$(".lang .current").text DeviceSettings.get "language"

			shareToggle:->
				@$(".share").toggleClass "on"

			toggleLang:->
				@$(".lang").toggleClass "on"

			soundToggle:->
				DeviceSettings.set "soundOn", !DeviceSettings.get "soundOn"
				do @render

			langToggle:(e)->
				do e.preventDefault
				lang = $(e.currentTarget).data "lang"
				DeviceSettings.set "language", lang if lang
				@$(".lang").removeClass "on"
				false

			demoToggle:(e)->
				DeviceSettings.set "demoMode", not DeviceSettings.get "demoMode"

		new DeviceControlView