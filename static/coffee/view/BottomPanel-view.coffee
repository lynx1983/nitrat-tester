define ["view/Panel-view", "model/DeviceSettings-model", "i18n/i18n"], (PanelView, DeviceSettings, i18n)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		template: _.template $('#bottom-panel-template').html()
		initialize: ->
			@$el.html @template
				t: i18n.t

	new BottomPanelView;
