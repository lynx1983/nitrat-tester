define ["view/Screen-view", "i18n/i18n"], (ScreenView, i18n)->
	class MenuScreenView extends ScreenView
		template: _.template $('#menu-template').html()
		initialize:->
			@activeIndex = 0
			@firstVisibleIndex = 0
			@itemsPerScreen = 6
			@items = @options.items
			@leftButtonText = @options.leftButtonText ? "cursor"
			@centerButtonText = @options.centerButtonText ? "measure"
			@rightButtonText = @options.centerButtonText ? "select"

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			@activeIndex = @firstVisibleIndex = 0 unless @options.notResetIndex
			@eventBus.on "button.click", @onButtonClick, @
			@eventBus.trigger "soft-button.setText", "left", @leftButtonText
			@eventBus.trigger "soft-button.setText", "center", @centerButtonText
			@eventBus.trigger "soft-button.setText", "right", @rightButtonText

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"
			@eventBus.off "button.click", @onButtonClick, @

		render:->
			@$el.html @template
				t: i18n.t
				title: @title
			startIndex = @firstVisibleIndex
			endIndex = startIndex + @itemsPerScreen
			for item, i in @items then do (item, i)=>
				if startIndex <= i < endIndex
					renderedItem = $(item.render().$el)
					if i is @activeIndex then renderedItem.addClass 'active' else renderedItem.removeClass 'active'
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
			console.log "Get event by screen [#{@name}]"
			switch button
				when 'left'
					@activeIndex++
					if @activeIndex - @firstVisibleIndex >= @itemsPerScreen 
						@firstVisibleIndex++
					if @activeIndex > @items.length - 1
						@activeIndex = @firstVisibleIndex = 0
					do @render

				when 'center'
					@eventBus.trigger "device.screen.prev"
					
				when 'right'		
					@items[@activeIndex].trigger "menu.item.action", button