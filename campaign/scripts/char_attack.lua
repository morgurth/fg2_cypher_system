-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	toggleDetail();
end

function toggleDetail()
	local bShow = (activatedetail.getValue() == 1);
	
	label_atkdetail.setVisible(bShow);
	label_atkskill.setVisible(bShow);
	training.setVisible(bShow);
	label_atkasset.setVisible(bShow);
	asset.setVisible(bShow);
	label_atkmod.setVisible(bShow);
	attack.setVisible(bShow);

	label_dmgdetail.setVisible(bShow);
	damage.setVisible(bShow);
	label_dmgtype.setVisible(bShow);
	damagetype.setVisible(bShow);
	
	label_range.setVisible(bShow);
	range.setVisible(bShow);
	label_ammo.setVisible(bShow);
	ammo.setVisible(bShow);
end

function actionAttack(draginfo)
	local rActor = ActorManager.getActor("pc", windowlist.window.getDatabaseNode());
	local sDesc = "[ATTACK] " .. name.getValue();

	local nTraining = training.getValue();
	if nTraining == 0 then
		sDesc = sDesc .. " [INABILITY]";
	elseif nTraining == 2 then
		sDesc = sDesc .. " [TRAINED]";
	elseif nTraining == 3 then
		sDesc = sDesc .. " [SPECIALIZED]";
	end

	local nStep = asset.getValue();
	if nStep ~= 0 then
		sDesc = sDesc .. string.format(" [ASSET %+d]", nStep);
	end

	local rRoll = { sType = "attack", sDesc = sDesc, aDice = { "d20" }, nMod = attack.getValue() };
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function actionDamage(draginfo)
	local rActor = ActorManager.getActor("pc", windowlist.window.getDatabaseNode());
	local sDesc = "[DAMAGE] " .. name.getValue();
	local sDmgType = damagetype.getValue();
	if sDmgType ~= "" then
		sDesc = sDesc .. " [TYPE: " .. sDmgType .. "]";
	end
	local rRoll = { sType = "damage", sDesc = sDesc, aDice = { }, nMod = damage.getValue() };
	ActionsManager.performAction(draginfo, rActor, rRoll);
end
