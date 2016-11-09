require("lib/managers/group_ai_states/GroupAIStateBesiege")
local _upd_assault_task_original = GroupAIStateBesiege._upd_assault_task

local previous_phase

function GroupAIStateBesiege:_upd_assault_task(...)
    _upd_assault_task_original(self, ...)

    local task = self._task_data.assault
    local phase = task.phase

    if managers.chat then
        if phase ~= previous_phase then
            if phase then
                local enemies = task.force_spawned
                local text = string.format("Current Assault Phase: %s with %d enemies", phase, enemies)
            else
                local text = "Current Assault Wave has finished!"
            end

            managers.chat:feed_system_message(ChatManager.GAME, text)
        end

        previous_phase = phase
    end
end
