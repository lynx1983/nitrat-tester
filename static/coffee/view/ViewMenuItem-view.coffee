define ["view/MenuItem-view"], (MenuItemView)->
	class ViewMenuItem extends MenuItemView
		tagName: 'li'
		template: _.template $('#view-menu-item-template').html()
		constructor: (options)->
			MenuItemView.call @, options
			@on "menu.item.action", @action
		
		action: -> 
			@eventBus.trigger "device.screen.set",
				screenName: @options.screen