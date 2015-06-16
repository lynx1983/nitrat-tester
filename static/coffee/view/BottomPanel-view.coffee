define ["view/Panel-view", "model/DeviceSettings-model", "i18n/i18n"], (PanelView, DeviceSettings, i18n)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		template: _.template $('#bottom-panel-template').html()
		leftState: ""
		rightState: ""
		centerState: "OK"

		initialize:->
			@eventBus.bind "device.button.setState", _.bind(@setButtonState, @)
			@eventBus.bind "device.button.removeState", _.bind(@removeButtonState, @)

		render:->
			@$el.html @template
				t: i18n.t
				leftState: @leftState
				rightState: @rightState
				centerState: @centerState

		setButtonState:(button, state)->
			@["#{button}State"] = state
			@$el.find(".soft-button.#{button}").addClass state

		removeButtonState:(button, state)->
			@["#{button}State"] = ""
			@$el.find(".soft-button.#{button}").removeClass state