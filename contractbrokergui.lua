inputstr = 1
local orig_search_key_press = ContractBrokerGui.search_key_press

function ContractBrokerGui:search_key_press(o, k)
    if ( k == Idstring("backspace") or k == Idstring("left") or k == Idstring("right") ) and self._now_inputing then
	    --Nothing
	else
	    orig_search_key_press(self, o, k)
	end
end

Hooks:PreHook(ContractBrokerGui, "update_key_down", "cbg_update_key_down_cn_backspace", function(self, o, k, ...)
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

Hooks:PreHook(ContractBrokerGui, "enter_text", "cbg_enter_text_cn_backspace", function(self, o, s, ...)
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
	if s and tostring(#s) % 3 == 0 then
	    local ns, ne = self._search.text:selection()
		if ns > 0 then
	        self._inputing_past = true
        else
		    self._inputing_past = false
		end
		self._cnlen_fix = math.min(utf8.len(self._search.text:text()) - ns, tonumber(#s) * 2 / 3) --和后面还剩下的字符个数比较一下
	end
end) 

Hooks:PostHook(ContractBrokerGui, "enter_text", "cbg_enter_text_cn_insert", function(self, o, s, ...)
    if s and self._inputing_past and tostring(#s) % 3 == 0 then
	    local ns, ne = self._search.text:selection()
		if self._inputing_past and #self._search.text:text() < 20 then
	        self._search.text:set_selection(ns - self._cnlen_fix , ne - self._cnlen_fix)
            self:update_caret()	
			self:_setup_change_search()
        end
	end
end) 

Hooks:PreHook(ContractBrokerGui, "search_key_release", "cbg_key_release_cn_backspace", function(self, o, k, ...)
    inputstr = 0
end) 
