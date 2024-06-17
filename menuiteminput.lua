inputstr = 1
local orig_key_press = MenuItemInput.key_press

function MenuItemInput:key_press(row_item, o, k)
    if ( k == Idstring("backspace") or k == Idstring("left") or k == Idstring("right") ) and self._now_inputing then
	    --Nothing
	else
	    orig_key_press(self, row_item, o, k)
	end
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
	
	wait(0.001) 
	
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
	if s and tostring(#s) % 3 == 0 then
	    local ns, ne = row_item.gui_text:selection()
		if ns > 0 then
	        self._inputing_past = true
        else
		    self._inputing_past = false
		end
		self._cnlen_fix = math.min(utf8.len(row_item.gui_text:text()) - ns, tonumber(#s) * 2 / 3) --和后面还剩下的字符个数比较一下
	end
end) 

Hooks:PostHook(MenuItemInput, "enter_text", "mii_enter_text_cn_insert", function(self, row_item, o, s, ...)
    if not row_item or not alive(row_item.gui_text) or not self._editing then
		return
	end
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
	if s and self._inputing_past and tostring(#s) % 3 == 0 then
	    local ns, ne = row_item.gui_text:selection()
		if self._inputing_past then
	        row_item.gui_text:set_selection(ns - self._cnlen_fix , ne - self._cnlen_fix)
            --self:handle_key(row_item, o, k)
	        self:_layout(row_item)	
        end
	end
end)


Hooks:PreHook(MenuItemInput, "key_release", "mii_key_release_cn_backspace", function(self, row_item, o, k, ...)
    if not row_item or not alive(row_item.gui_text) then
		return
	end
	inputstr = 0
end) 
