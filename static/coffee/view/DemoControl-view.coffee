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
				$stepTemplate = $("[data-step='#{@step}']")
				if $stepTemplate.length is 1
					timeout = $stepTemplate.data "timeout"
					do @$el.empty
					stepScreen = _.template $stepTemplate.html()
					@$el.html stepScreen t: i18n.t
					setTimeout @nextStep, timeout
				else 
					DeviceSettings.set "demoMode", false

			stop:->
				clearTimeout @stepTimeout
				do @$el.empty
				@step = 0

		new DemoControlView