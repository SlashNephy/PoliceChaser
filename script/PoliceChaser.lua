local text_original = LocalizationManager.text

function getFormattedPhase(phase)
    if phase == "anticipation" then
        return "Preparation"
    elseif phase == "fade" then
        return "Fade"
    elseif phase == "build" then
        return "Build"
    elseif phase == "sustain" then
        return "Sustain"
    end
    return string.format("Unknown (%s)", phase)
end

function updatePhase()
    if managers.chat then
        local groupaistate = managers.groupai:state()
        if groupaistate:get_hunt_mode() then
            local text = "This assault is Endless mode."
        else
            local phase = getFormattedPhase(groupaistate._task_data.assault.phase)

            local spawns = groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.force_pool) * groupaistate:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.force_pool_balance_mul)
            if spawns > 0 then
                local spawnleftText = string.format("%d spawns left", spawns - groupaistate._task_data.assault.force_spawned)
            else
                local spawnleftText = "No more spawnable"
            end

            local phaseTime = groupaistate._task_data.assault.phase_end_t + math.lerp(groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_min), groupaistate:_get_difficulty_dependent_value(tweak_data.group_ai.besiege.assault.sustain_duration_max), math.random()) * groupaistate:_get_balancing_multiplier(tweak_data.group_ai.besiege.assault.sustain_duration_balance_mul) + tweak_data.group_ai.besiege.assault.fade_duration * 2
            if phaseTime > 0 then
                local timeText = string.format("%.2f secs left", atime + 350 - groupaistate._t)
            else
                local timeText = "This phase has finished."
            end

            local waveText = string.format("Wave %d", groupaistate._wave_counter or 0)

            local text = string.format("Assault Phase: %s (%s) / %s / %s", phase, waveText, spawnleftText, timeText)
        end

        managers.chat:feed_system_message(ChatManager.GAME, text)
    end
end

function LocalizationManager:text(string_id, ...)
	if string_id == "hud_assault_enhanced" then
        updatePhase()
	end
	return text_original(self, string_id, ...)
end
