define ["view/Panel-view", "model/DeviceSettings-model"], (PanelView, DeviceSettings)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		template: _.template $('#bottom-panel-template').html()
		initialize: ->
			@$el.html @template

	new BottomPanelView;
