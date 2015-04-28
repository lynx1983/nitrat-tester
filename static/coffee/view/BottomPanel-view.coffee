define ["view/Panel-view", "model/DeviceSettings-model", "i18n/i18n"], (PanelView, DeviceSettings, i18n)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		
		initialize:->
			@template = _.template $('#bottom-panel-template').html()
			@leftButtonText = @options.leftButtonText ? ""
			@centerButtonText = @options.centerButtonText ? ""
			@rightButtonText = @options.rightButtonText ? ""
			@eventBus.on "soft-button.setText", @softButtonSetText, @
			@eventBus.on "soft-button.show", @softButtonShow, @
			@eventBus.on "soft-button.hide", @softButtonHide, @

		render:->
			@$el.html @template
				t: i18n.t
				leftText: @leftButtonText
				centerText: @centerButtonText
				rightText: @rightButtonText

		softButtonSetText: (button, text)->
			switch button
				when "left"
					@leftButtonText = text
				when "center"
					@centerButtonText = text
				when "right"
					@rightButtonText = text
			do @render

		softButtonShow: (button)->
			@$el.find(".#{button}").show()

		softButtonHide: (button)->
			@$el.find(".#{button}").hide()

	BottomPanelView
