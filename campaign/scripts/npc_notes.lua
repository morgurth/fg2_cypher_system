-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
	
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	updateControl("motive", bReadOnly);
	updateControl("environment", bReadOnly);
	updateControl("interaction", bReadOnly);
	updateControl("use", bReadOnly);
	updateControl("loot", bReadOnly);
	
	updateControl("text", bReadOnly);
end
