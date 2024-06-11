inputstr = 1
function ContractBrokerGui:search_key_press(o, k)
	if self._skip_first then
		self._skip_first = false

		return
	end

	if not self._enter_text_set then
		self._search.panel:enter_text(callback(self, self, "enter_text"))

		self._enter_text_set = true
	end

	local text = self._search.text
	local s, e = text:selection()
	local n = utf8.len(text:text())
	local d = math.abs(e - s)
	self._key_pressed = k

	text:stop()
	text:animate(callback(self, self, "update_key_down"), k)

	local len = utf8.len(text:text())

	text:clear_range_color(0, len)

	if k == Idstring("backspace") and not self._now_inputing then
		if s == e and s > 0 then
			text:set_selection(s - 1, e)
		end

		text:replace_text("")
	elseif k == Idstring("delete") then
		if s == e and s < n then
			text:set_selection(s, e + 1)
		end

		text:replace_text("")
	elseif k == Idstring("insert") then
		local clipboard = Application:get_clipboard() or ""

		text:replace_text(clipboard)

		local lbs = text:line_breaks()

		if ContractBrokerGui.MAX_SEARCH_LENGTH < #text:text() then
			text:set_text(string.sub(text:text(), 1, ContractBrokerGui.MAX_SEARCH_LENGTH))
		end

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
		if type(self._enter_callback) ~= "number" then
			self._enter_callback()
		end
	elseif k == Idstring("esc") and type(self._esc_callback) ~= "number" then
		if not _G.IS_VR then
			text:set_text("")
			text:set_selection(0, 0)
		end

		self._esc_callback()
	end

	self:update_caret()
end

Hooks:PreHook(ContractBrokerGui, "update_key_down", "cbg_update_key_down_cn_backspace", function(self, o, k, ...)
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

Hooks:PreHook(ContractBrokerGui, "enter_text", "cbg_enter_text_cn_backspace", function(self, o, s, ...)
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
end) 

Hooks:PreHook(ContractBrokerGui, "search_key_release", "cbg_key_release_cn_backspace", function(self, o, k, ...)
    inputstr = 0
end) 