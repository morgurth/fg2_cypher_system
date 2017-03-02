-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getPercentWounded(sNodeType, node)
	local nHP = 0;
	local nWounds = 0;
	
	local rActor = ActorManager.getActor(sNodeType, node);
	
	if rActor.sType == "pc" then
		nHP = 3;
		nWounds = DB.getValue(node, "wounds", 0);
	else
		nHP = DB.getValue(node, "hp", 0);
		nWounds = DB.getValue(node, "wounds", 0);
	end
	
	local nPercentWounded = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / nHP;
	end
	
	local sStatus;
	if rActor.sType == "pc" then
		if nWounds <= 0 then
			sStatus = "Hale";
		elseif nWounds == 1 then
			sStatus = "Impaired";
		elseif nWounds == 2 then
			sStatus = "Debilitated";
		else
			sStatus = "Dead";
		end
	else
		if nPercentWounded <= 0 then
			sStatus = "Healthy";
		elseif nPercentWounded < .5 then
			sStatus = "Wounded";
		elseif nPercentWounded < 1 then
			sStatus = "Heavy";
		else
			sStatus = "Dead";
		end
	end

	return nPercentWounded, sStatus, rActor;
end

function getWoundColor(sNodeType, node)
	local nPercentWounded, sStatus, rActor = getPercentWounded(sNodeType, node);
	if not rActor then
		return ColorManager.COLOR_HEALTH_UNWOUNDED, nPercentWounded, sStatus;
	end
	
	local sColor;
	if rActor.sType == "pc" then
		local nWounds = DB.getValue(node, "wounds", 0);
		if nWounds <= 0 then
			sColor = ColorManager.COLOR_HEALTH_UNWOUNDED;
		elseif nWounds == 1 then
			sColor = ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED;
		elseif nWounds == 2 then
			sColor = ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED;
		else
			sColor = ColorManager.COLOR_HEALTH_DYING_OR_DEAD;
		end
	else
		sColor = ColorManager.getHealthColor(nPercentWounded, false);
	end

	return sColor, nPercentWounded, sStatus;
end
