inputstr = 1
function MultiProfileItemGui:handle_key(k, pressed) 
	local text = self._name_text
	local s, e = text:selection()
	local n = utf8.len(text:text())
	local d = math.abs(e - s)

	if pressed then
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
		elseif k == Idstring("home") then
			text:set_selection(0, 0)
		elseif k == Idstring("end") then
			text:set_selection(n, n)
		end
	elseif k == Idstring("enter") then
		self:trigger()
	elseif k == Idstring("esc") then
		text:set_text(managers.multi_profile:current_profile_name())
		self:set_editing(false)
	end
end

Hooks:PreHook(MultiProfileItemGui, "update_key_down", "mpig_update_key_down_cn_backspace", function(self, o, k, ...)
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

Hooks:PreHook(MultiProfileItemGui, "enter_text", "mpig_enter_text_cn_backspace", function(self, o, s, ...)
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
end) 

Hooks:PreHook(MultiProfileItemGui, "key_release", "mpig_key_release_cn_backspace", function(self, o, k, ...)
    inputstr = 0
end) 
