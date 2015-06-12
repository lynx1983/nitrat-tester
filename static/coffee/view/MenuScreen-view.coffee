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
			console.log "Screen [#{@name}] custom activate"
			@activeIndex = 0 unless @options.notResetIndex
			@eventBus.on "button.click", @onButtonClick, @
			@eventBus.trigger "device.button.setState", "center", "OK"

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
			_.each @items, (item, i)=>
				if i >= startIndex and i < endIndex
					renderedItem = $(item.render().$el)
					if i == @activeIndex then renderedItem.addClass 'active' else renderedItem.removeClass 'active'
					@$el.find('.menu').append renderedItem
			
		onButtonClick:(button)->
			console.log "Get event by screen [#{@name}]"
			switch button
				when 'right'
					@activeIndex++
					if @activeIndex - @firstVisibleIndex >= @itemsPerScreen 
						@firstVisibleIndex++
					if @activeIndex > @items.length - 1
						@activeIndex = @firstVisibleIndex = 0
					@render()

				when 'center'		
					@items[@activeIndex].trigger "menu.item.action", button

				when 'left'
					@activeIndex--
					if @activeIndex < @firstVisibleIndex
						@firstVisibleIndex--
					if @activeIndex < 0
						@activeIndex = @items.length - 1
						if @items.length > @itemsPerScreen
							@firstVisibleIndex = @items.length - @itemsPerScreen
							@firstVisibleIndex = 0 if @firstVisibleIndex < 0
					@render()