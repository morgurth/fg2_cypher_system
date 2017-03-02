-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerResultHandler("dice", onRoll);
	ActionsManager.registerResultHandler("skill", onRoll);
end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	
	if #(rRoll.aDice) == 1 and rRoll.aDice[1].type == "d20" then
		local aAddIcons = {};
		
		local nFirstDie = rRoll.aDice[1].result or 0;
		if nFirstDie >= 20 then
			rMessage.text = rMessage.text .. " [MAJOR EFFECT]";
			table.insert(aAddIcons, "roll20");
		elseif nFirstDie == 19 then
			rMessage.text = rMessage.text .. " [MINOR EFFECT]";
			table.insert(aAddIcons, "roll19");
		elseif nFirstDie == 1 then
			rMessage.text = rMessage.text .. " [GM INTRUSION]";
			table.insert(aAddIcons, "roll1");
		end
		
		local nTraining = 0;
		if string.match(rRoll.sDesc, "%[TRAINED%]") then
			nTraining = 1;
		elseif string.match(rRoll.sDesc, "%[SPECIALIZED%]") then
			nTraining = 2;
		elseif string.match(rRoll.sDesc, "%[INABILITY%]") then
			nTraining = -1;
		end
		
		local sAsset = string.match(rRoll.sDesc, "%[ASSET ([+-]%d+)%]");
		local nAsset = 0;
		if sAsset then
			nAsset = tonumber(sAsset) or 0;
		end

		local nTotal = ActionsManager.total(rRoll);
		local nSuccess = math.floor(nTotal / 3) + nTraining + nAsset;
		nSuccess = math.max(0, math.min(10, nSuccess));
		
		table.insert(aAddIcons, "task" .. nSuccess);
		
		if #aAddIcons > 0 then
			rMessage.icon = { rMessage.icon };
			for _,v in ipairs(aAddIcons) do
				table.insert(rMessage.icon, v);
			end
		end
	end
	
	Comm.deliverChatMessage(rMessage);
end
