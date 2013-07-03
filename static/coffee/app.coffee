require ["underscore", "backbone", "view/Device-view", "view/MenuScreen-view"], 
	(_, Backbone, DeviceView, MenuScreenView) ->
		MainMenuScreen = new MenuScreenView
			name: "main-menu"
		
		DeviceView.addScreen MainMenuScreen

		Device.setCurrentScreen "main-menu"