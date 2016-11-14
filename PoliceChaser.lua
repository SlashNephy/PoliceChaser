if not Steam then
	return
end

PoliceChaser = PoliceChaser or {}
if not PoliceChaser.setup then
	-- Grobal var for ext
	PoliceChaser._pre_phase = "pre"
	PoliceChaser._current_phase = "current"

	-- Grobal util var
	PoliceChaser._path = ModPath
	PoliceChaser._lua_path = ModPath .. "lua/"
	PoliceChaser._hook_files = {
		["lib/managers/hud/hudassaultcorner"] = "HUDAssaultCorner.lua",
		["lib/managers/localizationmanager"] = "LocalizationManager.lua"
	}

	function PoliceChaser:SafeDoFile(fileName)
		local success, errorMsg = pcall(function()
			if io.file_is_readable(fileName) then
				dofile(fileName)
			else
				log("[PoliceChaser Error] Could not open file '" .. fileName .. "'! Does it exist, is it readable?")
			end
		end)
		if not success then
			log("[PoliceChaser Error]\nFile: " .. fileName .. "\n" .. errorMsg)
		end
	end

	function PoliceChaser:ReceiveChatMessage(prefix, message, color)
	log("called")
    	if not message then
        	message = prefix
            prefix = nil
    	end
    	if not tostring(color):find('Color') then
        	color = nil
    	end
    	message = tostring(message)
		log("to str")
    	if managers and managers.chat and managers.chat._receivers and managers.chat._receivers[1] then
        	for __, rcvr in pairs(managers.chat._receivers[1]) do
            	rcvr:receive_message(prefix or "*", message, color or tweak_data.chat_colors[5]) 
				log("for")
        	end  
      	end
	end

	PoliceChaser.setup = true
	log("[PoliceChaser] Load completed.")
end

if RequiredScript then
	local requiredScript = RequiredScript:lower()
	if PoliceChaser._hook_files[requiredScript] then
		PoliceChaser:SafeDoFile(PoliceChaser._lua_path .. PoliceChaser._hook_files[requiredScript])
	else
		log("[PoliceChaser] unlinked script called: " .. requiredScript)
	end
end
