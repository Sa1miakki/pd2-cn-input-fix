inputstr = 1
function MenuItemInput:key_press(row_item, o, k)
	if not row_item or not alive(row_item.gui_text) or not self._editing then
		return
	end

	local text = row_item.gui_text
	local s, e = text:selection()
	local n = utf8.len(text:text())
	local d = math.abs(e - s)
	self._key_pressed = k

	text:stop()
	text:animate(callback(self, self, "update_key_down", row_item), k)

	if k == Idstring("backspace") and not self._now_inputing then
		if s == e and s > 0 then
			text:set_selection(s - 1, e)
		end

		text:replace_text("")

		if utf8.len(text:text()) < 1 and type(self._esc_released_callback) ~= "number" then
			-- Nothing
		end
	elseif k == Idstring("delete") then
		if s == e and s < n then
			text:set_selection(s, e + 1)
		end

		text:replace_text("")

		if utf8.len(text:text()) < 1 and type(self._esc_released_callback) ~= "number" then
			-- Nothing
		end
	elseif k == Idstring("insert") then
		local clipboard = Application:get_clipboard() or ""

		text:replace_text(clipboard)

		local lbs = text:line_breaks()

		if #lbs > 1 then
			local s = lbs[2]
			local e = utf8.len(text:text())

			text:set_selection(s, e)
			text:replace_text("")
		end
	elseif k == Idstring("left") then
		if s < e then
			text:set_selection(s, s)
		elseif s > 0 then
			text:set_selection(s - 1, s - 1)
		end
	elseif k == Idstring("right") then
		if s < e then
			text:set_selection(e, e)
		elseif s < n then
			text:set_selection(s + 1, s + 1)
		end
	elseif self._key_pressed == Idstring("end") then
		text:set_selection(n, n)
	elseif self._key_pressed == Idstring("home") then
		text:set_selection(0, 0)
	elseif k == Idstring("enter") then
		self._should_disable = true
	end

	self:_layout(row_item)
end

Hooks:PreHook(MenuItemInput, "update_key_down", "mii_update_key_down_cn_backspace", function(self, row_item, o, k, ...)
    if not row_item or not alive(row_item.gui_text) then
		return
	end
	
	local match = false
   
    for i = 97, 122 do 
        if k == Idstring(string.char(i)) then
            match = true
            break
        end
    end
	
	wait(0.001) --因为按下按键是最先执行的，所以直接将它延后0.001s
	
	if match and inputstr == 0 then
		self._now_inputing = true
	end
end) 

Hooks:PreHook(MenuItemInput, "enter_text", "mii_enter_text_cn_backspace", function(self, row_item, o, s, ...)
    if not row_item or not alive(row_item.gui_text) or not self._editing then
		return
	end
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
end) 

Hooks:PreHook(MenuItemInput, "key_release", "mii_key_release_cn_backspace", function(self, row_item, o, k, ...)
    if not row_item or not alive(row_item.gui_text) then
		return
	end
	inputstr = 0
end) 
