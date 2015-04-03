define [
	"global"
	"view/EventDriven-view"
	"model/DeviceSettings-model"
	"i18n/i18n"
	], (global, EventDrivenView, DeviceSettings, i18n)->
		class DemoControlView extends EventDrivenView
			el: $('.demo-layout')
		
			initialize:->
				super
				@step = 0
				@stepTimeout = null
				DeviceSettings.on "change:demoMode", @onStateChange, @

			onStateChange:->
				if DeviceSettings.get "demoMode"
					do @start
				else
					do @stop

			start:->
				do global.device.start
				do @nextStep

			nextStep:=>
				@step++
				$stepScreen = @$("[data-step='#{@step}']")
				if $stepScreen.length is 1
					timeout = $stepScreen.data "timeout"
					do @$(".step").hide
					do $stepScreen.show
					setTimeout @nextStep, timeout
				else 
					DeviceSettings.set "demoMode", false

			stop:->
				clearTimeout @stepTimeout
				do @$(".step").hide
				@step = 0

		new DemoControlView