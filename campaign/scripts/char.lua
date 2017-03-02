-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if User.isHost() then
		registerMenuItem(Interface.getString("menu_rest"), "lockvisibilityon", 8);
		registerMenuItem(Interface.getString("menu_restovernight"), "pointer_circle", 8, 6);
	end

	if User.isLocal() then
		portrait.setVisible(false);
		localportrait.setVisible(true);
	end
end

function onMenuSelection(selection, subselection)
	if selection == 8 then
		local nodeChar = getDatabaseNode();
		
		if subselection == 6 then
			ChatManager.Message(Interface.getString("message_restovernight"), true, ActorManager.getActor("pc", nodeChar));
			CharManager.rest(nodeChar);
		end
	end
end
