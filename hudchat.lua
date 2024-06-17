inputstr = 1
local orig_key_press = HUDChat.key_press

function HUDChat:key_press(o, k)
    if ( k == Idstring("backspace") or k == Idstring("left") or k == Idstring("right") ) and self._now_inputing then
	    --Nothing
	else
	    orig_key_press(self, o, k)
	end
end

Hooks:PreHook(HUDChat, "update_key_down", "hc_update_key_down_cn_backspace", function(self, o, k, ...)
    local match = false
    for i = 97, 122 do 
        if k == Idstring(string.char(i)) then
            match = true
            break
        end
    end
	
	wait(0.001)
	
	if match and inputstr == 0 then
		self._now_inputing = true
	end
end) 

Hooks:PreHook(HUDChat, "enter_text", "hc_enter_text_cn_backspace", function(self, o, s, ...)
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
	if s and tostring(#s) % 3 == 0 then
	    local ns, ne = self._input_panel:child("input_text"):selection()
		if ns > 0 then
	        self._inputing_past = true
        else
		    self._inputing_past = false
		end
		self._cnlen_fix = math.min(utf8.len(self._input_panel:child("input_text"):text()) - ns, tonumber(#s) * 2 / 3) --和后面还剩下的字符个数比较一下
	end
end) 

Hooks:PostHook(HUDChat, "enter_text", "hc_enter_text_cn_insert", function(self, o, s, ...)
	if s and self._inputing_past and tostring(#s) % 3 == 0 then
	    local ns, ne = self._input_panel:child("input_text"):selection()
		if self._inputing_past then
	        self._input_panel:child("input_text"):set_selection(ns - self._cnlen_fix , ne - self._cnlen_fix)
            self:update_caret()	
        end
	end
end)

Hooks:PreHook(HUDChat, "key_release", "hc_key_release_cn_backspace", function(self, o, k, ...)
    inputstr = 0
end) 
