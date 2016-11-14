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
	local finaltext = "Assault Phase: "
	if groupaistate:get_hunt_mode() then
		finaltext = finaltext .. "endless"
		message = "endless"
	else
		finaltext = finaltext .. groupaistate._task_data.assault.phase
		message = groupaistate._task_data.assault.phase
		local spawns = groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.force_pool) * groupaistate:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.force_pool_balance_mul)
		if spawns >= 0 then
			finaltext = finaltext .. " /// Spawns Left: " .. string.format("%d", spawns - groupaistate._task_data.assault.force_spawned)
		end
		local atime = groupaistate._task_data.assault.phase_end_t + math.lerp(groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_min), groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_max), math.random()) * groupaistate:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.sustain_duration_balance_mul) + tweak_data.group_ai.besiege.assault.fade_duration * 2
		if atime < 0 then
			finaltext = finaltext .. " /// OVERDUE"
		elseif atime > 0 then
			finaltext = finaltext .. " /// Time Left: " .. string.format("%.2f", atime + 350 - groupaistate._t)
		end
	end
	finaltext = finaltext .. " /// Wave: " .. string.format("%d", groupaistate._wave_counter or 0)
	PoliceChaser._current_phase = groupaistate._task_data.assault.phase
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
		-- PoliceChaser:ReceiveChatMessage("Assault", message .. " Wave" .. groupaistate._wave_counter or 0)
		if managers and managers.chat and managers.chat._receivers and managers.chat._receivers[1] then
        	for __, rcvr in pairs(managers.chat._receivers[1]) do
            	rcvr:receive_message("Assault", message, color or tweak_data.chat_colors[5]) 
        	end  
      	end

		PoliceChaser._pre_phase = PoliceChaser._current_phase
	end
	return finaltext
end
