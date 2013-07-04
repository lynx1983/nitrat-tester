define ["view/Screen-view"], (ScreenView)->
	class MenuScreenView extends ScreenView
		template: _.template $('#menu-template').html()
		initialize: ()->
			@activeIndex = 0
			@itemsPerScreen = 6
			@items = @options.items
			@on "button.left.click", @onLeftButton
			@on "button.center.click", @onCenterButton
			@on "button.right.click", @onRightButton
			@on "button.up.click", @onUpButton
			@on "button.down.click", @onDownButton

		render: ()->
			@$el.html @.template
				title: @title
			startIndex = @getItemScreenIndex() * @itemsPerScreen
			endIndex = startIndex + @itemsPerScreen
			_.each @items, (item, i)=>
				if i >= startIndex and i < endIndex
					renderedItem = $(item.render().$el)
					if i == @activeIndex then renderedItem.addClass 'active' else renderedItem.removeClass 'active'
					@$el.find('.menu').append renderedItem
			
			if startIndex > 0 and endIndex < @items.length
				@eventBus.trigger "list-indicator.set",
					state: 'both'
			else if startIndex > 0 
				@eventBus.trigger "list-indicator.set",
					state: 'up'
			else if endIndex < @items.length
				@eventBus.trigger "list-indicator.set",
					state: 'down'
			else
				@eventBus.trigger "list-indicator.set"
			@

		getItemScreenIndex: ->
			Math.floor @activeIndex / @itemsPerScreen

		onUpButton: ->
			@activeIndex--
			@activeIndex = @items.length - 1 if @activeIndex < 0
			@render()

		onDownButton: ->
			@activeIndex++
			@activeIndex = 0 if @activeIndex > @items.length - 1
			@render()

		onLeftButton: ->
			@eventBus.trigger "device.screen.prev"

		onRightButton: ->
			@items[@activeIndex].trigger "menu.item.action"
