require("lib/managers/groupaimanager")
local _update_original = GroupAIManager.update

local previous_phase

function GroupAIManager:update(...)
    _update_original(self, ...)

    if self._state_name == "besiege" then
        local phase = self._state._task_data.assault.phase
        if phase and phase ~= previous_phase then
            previous_phase = phase

            if managers.chat then
                local remaining = self._state._task_data.assault.phase_end_t - self._state._t
                local text = string.format("Current Assault Phase: %s (Remaining %d secs)", phase, remaining)
                managers.chat:feed_system_message(ChatManager.GAME, text)
            end
        end
    end
end
