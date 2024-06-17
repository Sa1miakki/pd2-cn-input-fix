inputstr = 1

local orig_key_press = NewSkillTreeGui.key_press

function NewSkillTreeGui:key_press(o, k)
    if ( k == Idstring("backspace") or k == Idstring("left") or k == Idstring("right") ) and self._now_inputing then
	    --Nothing(其实这里本身按左右键就没反应，ovk没做这东西)
	else
	    orig_key_press(self, o, k)
	end
end

Hooks:PreHook(NewSkillTreeGui, "update_key_down", "stg_update_key_down_cn_backspace", function(self, o, k, ...)
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

Hooks:PreHook(NewSkillTreeGui, "enter_text", "stg_enter_text_cn_backspace", function(self, o, s, ...)
    if s then inputstr = tostring(#s) else inputstr = 1 end
	self._now_inputing = false
end) 

Hooks:PreHook(NewSkillTreeGui, "key_release", "stg_key_release_cn_backspace", function(self, o, k, ...)
    inputstr = 0
end) 
