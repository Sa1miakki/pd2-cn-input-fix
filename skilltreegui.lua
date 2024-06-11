inputstr = 1
function NewSkillTreeGui:key_press(o, k) 
	local text = self._renaming_skill_switch
	local n = utf8.len(text)
	self._key_pressed = k

	self._skillset_panel:stop()
	self._skillset_panel:animate(callback(self, self, "update_key_down"), k)

	if k == Idstring("backspace") and not self._now_inputing then
		text = utf8.sub(text, 0, math.max(n - 1, 0))
	elseif k == Idstring("delete") then
		-- Nothing
	elseif k == Idstring("left") then
		-- Nothing
	elseif k == Idstring("right") then
		-- Nothing
	elseif self._key_pressed == Idstring("end") then
		-- Nothing
	elseif self._key_pressed == Idstring("home") then
		-- Nothing
	elseif k == Idstring("enter") then
		if _G.IS_VR then
			self:_stop_rename_skill_switch()

			return
		end
	elseif k == Idstring("esc") then
		self:_cancel_rename_skill_switch()

		return
	elseif k == Idstring("left ctrl") or k == Idstring("right ctrl") then
		self._key_ctrl_pressed = true
	elseif self._key_ctrl_pressed == true and k == Idstring("v") then
		return
	end

	if text ~= self._renaming_skill_switch then
		self._renaming_skill_switch = text

		self:_update_rename_skill_switch()
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
	
	wait(0.001) --因为按下按键是最先执行的，所以直接将它延后0.001s
	
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
