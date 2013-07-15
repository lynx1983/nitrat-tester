define ["view/Screen-view", "i18n/i18n"], (ScreenView, i18n)->
	class MenuScreenView extends ScreenView
		template: _.template $('#menu-template').html()
		initialize: ()->
			@activeIndex = 0
			@firstVisibleIndex = 0
			@itemsPerScreen = 6
			@items = @options.items

		activate:->
			super
			console.log "Screen [" + @name + "] custom activate"
			@eventBus.on "button.click", @onButtonClick, @

		deactivate:->
			super			
			console.log "Screen [" + @name + "] custom deactivate"
			@eventBus.off "button.click", @onButtonClick, @

		render: ()->
			@$el.html @template
				t: i18n.t
				title: @title
			startIndex = @firstVisibleIndex
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

		onButtonClick:(button)->
			console.log "Get event by screen [" + @name + "]"
			switch button
				when 'up'
					@activeIndex--
					if @activeIndex - @firstVisibleIndex < 0 
						@firstVisibleIndex--
					if @activeIndex < 0
						@activeIndex = @items.length - 1
						@firstVisibleIndex = if @items.length - @itemsPerScreen < 0 then 0 else @items.length - @itemsPerScreen
					@render()

				when 'down'
					@activeIndex++
					if @activeIndex - @firstVisibleIndex >= @itemsPerScreen 
						@firstVisibleIndex++
					if @activeIndex > @items.length - 1
						@activeIndex = @firstVisibleIndex = 0
					@render()

				when 'left'
					@eventBus.trigger "device.screen.prev"
					
				when 'right'		
					@items[@activeIndex].trigger "menu.item.action", button