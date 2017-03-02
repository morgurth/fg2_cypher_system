-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false;
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID, bOptionID = ItemManager.getIDState(nodeRecord);
	local bHost = User.isHost();
	
	if bOptionID and bHost then
		updateControl("nonid_name", bReadOnly, true);
	else
		updateControl("nonid_name", bReadOnly, false);
	end
	if bOptionID and (bHost or not bID) then
		updateControl("nonid_notes", bReadOnly, true);
	else
		updateControl("nonid_notes", bReadOnly, false);
	end
	
	type.setVisible(bID);
	type.setReadOnly(bReadOnly);
	type_label.setVisible(bID);
	local sType = type.getStringValue();
	
	local bArmor = (sType == "armor");
	local bWeapon = (sType == "weapon");
	local bCypher = (sType == "cypher");
	local bArtifact = (sType == "artifact");
	local bEquipment = (sType == "");
	
	updateControl("subtype", bReadOnly, bID and (bArmor or bWeapon));
	updateControl("cost", bReadOnly, bID and (bArmor or bWeapon or bEquipment));
	updateControl("armor", bReadOnly, bID and bArmor);
	updateControl("damage", bReadOnly, bID and bWeapon);
	updateControl("level", bReadOnly, bID and (bCypher or bArtifact));
	depletion.setVisible(bID and bArtifact);
	depletion_label.setVisible(bID and bArtifact);
	depletion.setReadOnly(bReadOnly);
	depletiondie.setVisible(bID and bArtifact);
	depletiondie_label.setVisible(bID and bArtifact);
	depletiondie.setReadOnly(bReadOnly);
	slots.setVisible(bID and bCypher);
	slots_label.setVisible(bID and bCypher);
	slots.setReadOnly(bReadOnly);

	notes.setVisible(bID);
	notes.setReadOnly(bReadOnly);
		
	divider.setVisible(bOptionID and bHost);
	divider2.setVisible(bID);
end

function actionDepletion(draginfo)
	local node = getDatabaseNode();
	local sName = DB.getValue(node, "name", "");
	local sDepletionDie = DB.getValue(node, "depletiondie", "");
	local nDepletion = DB.getValue(node, "depletion", 0);
	
	local rRoll = {};
	rRoll.sDesc = "[" .. Interface.getString("depletion_tag") .. "] " .. sName;
	rRoll.sType = "depletion";
	rRoll.aDice = {};
	rRoll.nMod = 0;

	if sDepletionDie ~= "" then
		rRoll.sDesc = rRoll.sDesc .. " (" .. nDepletion .. " " .. Interface.getString("item_label_depletionin") .. " 1" .. sDepletionDie .. ")";
		table.insert(rRoll.aDice, sDepletionDie);
		if sDepletionDie == "d100" then
			table.insert(rRoll.aDice, "d10");
		end
	elseif draginfo then
		draginfo.setType("number");
		draginfo.setDescription(rRoll.sDesc);
		draginfo.setNumberData(nDepletion);
		return;
	else
		rRoll.nMod = nDepletion;
	end
	
	ActionsManager.performAction(draginfo, nil, rRoll);
end
