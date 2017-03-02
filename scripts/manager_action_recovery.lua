-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerResultHandler("recovery", onRoll);
end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	if sActorType == "pc" then
		local c = DB.getValue(nodeActor, "recoveryused", 0);
		if c >= 4 then
			rMessage.text = rMessage.text .. " [NO RECOVERIES REMAINING]";
		elseif c == 3 then
			rMessage.text = rMessage.text .. " [10 HOURS]";
		elseif c == 2 then
			rMessage.text = rMessage.text .. " [1 HOUR]";
		elseif c == 1 then
			rMessage.text = rMessage.text .. " [10 MINUTES]";
		else
			rMessage.text = rMessage.text .. " [1 ACTION]";
		end
		if c < 4 then
			DB.setValue(nodeActor, "recoveryused", "number", c + 1);
		end
	end
	
	Comm.deliverChatMessage(rMessage);
end
