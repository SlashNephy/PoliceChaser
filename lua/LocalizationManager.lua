local text_original = LocalizationManager.text

function LocalizationManager:text(string_id, ...)
	if string_id == "hud_assault_enhanced" then
		return self:hud_assault_enhanced()
	else
		return text_original(self, string_id, ...)
	end
end

function LocalizationManager:hud_assault_enhanced()
	local message
	local groupaistate = managers.groupai:state()
	if groupaistate:get_hunt_mode() then
		message = "endless"
	else
		message = groupaistate._task_data.assault.phase
	end
		PoC._current_phase = groupaistate._task_data.assault.phase

		if not PoliceChaser._pre_phase or PoliceChaser._pre_phase ~= PoliceChaser._current_phase then
			if message == "build" then
				message = "Build"
			elseif message == "sustain" then
				message = "Sustain"
			elseif message == "fade" then
				message = "Fade"
			else
				message = "Endless"
			end

			PoliceChaser:ReceiveChatMessage("Assault", message .. " Wave" .. groupaistate._wave_counter or 0)
			
			PoliceChaser._pre_phase = PoliceChaser._current_phase
		end
	end
end
