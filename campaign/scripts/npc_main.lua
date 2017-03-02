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

	level.setReadOnly(bReadOnly);
	
	hp.setReadOnly(bReadOnly);
	damagestr.setReadOnly(bReadOnly);
	updateControl("armor", bReadOnly);
	move.setReadOnly(bReadOnly);
	updateControl("modifications", bReadOnly);
	updateControl("combat", bReadOnly);
	updateControl("intrusion", bReadOnly);
end
