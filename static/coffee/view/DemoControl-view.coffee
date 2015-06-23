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
					@["step#{@step}"]?()
					@stepTimeout = setTimeout @nextStep, timeout
				else 
					DeviceSettings.set "demoMode", false

			stop:->
				clearTimeout @stepTimeout
				do @$el.empty
				@step = 0
				do global.device.start

			step3:->
				@eventBus.trigger "button.click", "center"

			step5:->
				@eventBus.trigger "button.click", "center"

			step6:->
				@eventBus.trigger "button.click", "right"

			step7:->
				@eventBus.trigger "button.click", "center"

			step8:->
				@eventBus.trigger "button.click", "center"

			step9:->
				@eventBus.trigger "button.click", "right"

			step10:->
				@eventBus.trigger "button.click", "right"

			step11:->
				@eventBus.trigger "button.click", "center"

			step12:->
				@eventBus.trigger "button.click", "center"

		new DemoControlView