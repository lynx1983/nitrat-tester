define ["view/Panel-view", "model/DeviceSettings-model", "i18n/i18n"], (PanelView, DeviceSettings, i18n)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		template: _.template $('#bottom-panel-template').html()

		initialize:->
			@eventBus.on "soft-button.setText", @softButtonSetText, @
			@eventBus.on "soft-button.show", @softButtonShow, @
			@eventBus.on "soft-button.hide", @softButtonHide, @

		render:->
			@$el.html @template
				t: i18n.t

		softButtonSetText: (button, text)->
			@$el.find(".#{button}").text(i18n.t text)

		softButtonShow: (button)->
			@$el.find(".#{button}").show()

		softButtonHide: (button)->
			@$el.find(".#{button}").hide()

	new BottomPanelView;
