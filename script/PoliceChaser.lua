require("lib/managers/groupaimanager")
local _update_original = GroupAIManager.update

local previous_phase

function isSupportedPhase(phase)
    if phase == "anticipation" or phase == "fade" or phase == "build" or phase == "sustain" then
        return true
    end
    return false
end

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
    return "Unknown"
end

function GroupAIManager:update(...)
    _update_original(self, ...)

    if self._state_name == "besiege" and managers.chat then
        local phase = getFormattedPhase(self._state._task_data.assault.phase)

        if phase and phase ~= previous_phase then
            previous_phase = phase

            if isSupportedPhase(phase) then
                local text = string.format("Current Assault Phase: %s", phase)
                managers.chat:feed_system_message(ChatManager.GAME, text)
            end
        end
    end
end
