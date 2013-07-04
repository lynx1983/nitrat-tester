define ["view/MenuItem-view"], (MenuItemView)->
	class TextMenuItem extends MenuItemView
		tagName: 'li'
		template: _.template $('#text-menu-item-template').html()
		
		initialize: ->
			@text = @options.text