-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local rsname = "Numenera";

function onInit()
	if User.isHost() or User.isLocal() then
		updateCampaign();
	end

	DB.onAuxCharLoad = onCharImport;
	DB.onImport = onImport;
	Module.onModuleLoad = onModuleLoad;
end

function onCharImport(nodePC)
	local _, _, aMajor, _ = DB.getImportRulesetVersion();
	updateChar(nodePC, aMajor[rsname]);
end

function onImport(node)
	local aPath = StringManager.split(node.getNodeName(), ".");
	if #aPath == 2 and aPath[1] == "charsheet" then
		local _, _, aMajor, _ = DB.getImportRulesetVersion();
		updateChar(node, aMajor[rsname]);
	end
end

function onModuleLoad(sModule)
	local _, _, aMajor, _ = DB.getRulesetVersion(sModule);
	updateModule(sModule, aMajor[rsname]);
end

function updateChar(nodePC, nVersion)
	if not nVersion then
		nVersion = 0;
	end
	
	if nVersion < 4 then
		if nVersion < 2 then
			migrateChar2(nodePC);
		end
		if nVersion < 3 then
			migrateChar3(nodePC);
		end
		if nVersion < 4 then
			migrateChar4(nodePC);
		end
	end
end

function updateCampaign()
	local _, _, aMajor, aMinor = DB.getRulesetVersion();
	local major = aMajor[rsname];
	if not major then
		return;
	end
	
	if major > 0 and major < 4 then
		print("Migrating campaign database to latest data version.");
		DB.backup();
		
		if major < 2 then
			convertCharacters2();
		end
		if major < 3 then
			convertCharacters3();
		end
		if major < 4 then
			convertCharacters4();
			convertParty4();
		end
	end
end

function updateModule(sModule, nVersion)
	if not nVersion then
		nVersion = 0;
	end
	
	if nVersion < 4 then
		-- No module updates yet
	end
end

function convertParty4()
	ItemManager.handleCurrency("partysheet", "Shins", DB.getValue("partysheet.shins", 0));
	DB.deleteNode("partysheet.shins");
	DB.deleteNode("partysheet.partyshins");
end

function migrateChar4(nodeChar)
	DB.setValue(nodeChar, "coins.slot1.amount", "number", DB.getValue(nodeChar, "shins", 0));
	DB.deleteChild(nodeChar, "shins");
	DB.setValue(nodeChar, "coins.slot1.name", "string", "Shins");
end

function convertCharacters4()
	for _,nodeChar in pairs(DB.getChildren("charsheet")) do
		migrateChar4(nodeChar);
	end
end

function migrateChar3(nodeChar)
	DB.setValue(nodeChar, "abilities.might.def.training", "number", DB.getValue(nodeChar, "abilities.might.defense", 1));
	DB.setValue(nodeChar, "abilities.speed.def.training", "number", DB.getValue(nodeChar, "abilities.speed.defense", 1));
	DB.setValue(nodeChar, "abilities.intellect.def.training", "number", DB.getValue(nodeChar, "abilities.intellect.defense", 1));
end

function convertCharacters3()
	for _,nodeChar in pairs(DB.getChildren("charsheet")) do
		migrateChar3(nodeChar);
	end
end

function migrateChar2(nodeChar)
	local nodeSkills = nodeChar.createChild("skilllist");
	
	for _,vSkill in pairs(DB.getChildren(nodeChar, "skills.might")) do
		local nodeNewSkill = nodeSkills.createChild();
		DB.copyNode(vSkill, nodeNewSkill);
	end
	DB.deleteChild(nodeChar, "skills.might");
	
	for _,vSkill in pairs(DB.getChildren(nodeChar, "skills.speed")) do
		local nodeNewSkill = nodeSkills.createChild();
		DB.copyNode(vSkill, nodeNewSkill);
	end
	DB.deleteChild(nodeChar, "skills.speed");

	for _,vSkill in pairs(DB.getChildren(nodeChar, "skills.intellect")) do
		local nodeNewSkill = nodeSkills.createChild();
		DB.copyNode(vSkill, nodeNewSkill);
	end
	DB.deleteChild(nodeChar, "skills.intellect");
end

function convertCharacters2()
	for _,nodeChar in pairs(DB.getChildren("charsheet")) do
		migrateChar2(nodeChar);
	end
end
