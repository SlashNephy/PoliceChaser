local _start_assault_original = HUDAssaultCorner._start_assault
function HUDAssaultCorner:_start_assault(text_list, ...)
	if Network:is_server() then
		for i = 1, 1000 do
			if text_list[i] == "hud_assault_assault" then
				text_list[i] = "hud_assault_enhanced"
			end
		end
	end
	return _start_assault_original(self, text_list, ...)
end