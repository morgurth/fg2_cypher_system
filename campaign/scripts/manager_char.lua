-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ItemManager.setCustomCharAdd(onCharItemAdd);
end

function updateCyphers(nodeChar)
	local nCypherTotal = 0;
	local nCypherValue = 0;

	for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
		if DB.getValue(vNode, "type", "") == "cypher" then
			if DB.getValue(vNode, "slots", "") == "used" or DB.getValue(vNode, "slots", "") == "" then
				nCypherValue = 0;
			elseif DB.getValue(vNode, "slots", "") == "manifest" or DB.getValue(vNode, "slots", "") == "subtle" then
				nCypherValue = 1;
			end
			
			-- Replacing DB.getValue with nCypherValue - SA
			--nCypherTotal = nCypherTotal + DB.getValue(vNode, "slots", 1);
			nCypherTotal = nCypherTotal + nCypherValue;
		end
	end

	DB.setValue(nodeChar, "cypherload", "number", nCypherTotal);
end

function onCharItemAdd(nodeItem)
	if DB.getValue(nodeItem, "type", "") == "cypher" then
		if DB.getValue(nodeItem, "slots", 0) < 1 then
			DB.setValue(nodeItem, "slots", "number", 1);
		end
	end
end

--
-- ACTIONS
--

function rest(nodeChar)
	DB.setValue(nodeChar, "recoveryused", "number", 0);
end
