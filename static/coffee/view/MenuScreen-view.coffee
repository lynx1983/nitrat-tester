define ["underscore", "view/Screen-view"], (_, ScreenView)->
	class MenuScreenView extends ScreenView
		template: _.template $('#menu-template').html()
		initialize: ()->
			@activeIndex = 0
			@items = @options.items
			@on "button.left.click", @onLeftButton
			@on "button.center.click", @onCenterButton
			@on "button.right.click", @onRightButton
			@on "button.up.click", @onUpButton
			@on "button.down.click", @onDownButton

		render: ()->
			@$el.html @.template
				title: @title
			_.each @items, (item, i)=>
				renderedItem = $(item.render().$el)
				if i == @activeIndex then renderedItem.addClass 'active' else renderedItem.removeClass 'active'
				@$el.find('.menu').append renderedItem
			@

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
