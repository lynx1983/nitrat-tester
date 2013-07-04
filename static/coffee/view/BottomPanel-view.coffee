define ["backbone", "view/Panel-view", "model/DeviceSettings-model"], (Backbone, PanelView, DeviceSettings)->	
	class BottomPanelView extends PanelView
		el: '#device-wrapper .bottom-panel'
		template: _.template $('#bottom-panel-template').html()
		initialize: ->
			@$el.html @template

	new BottomPanelView;
