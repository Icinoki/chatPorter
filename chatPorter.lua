--[[
Copyright (c) 2013, Ikonic
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of chatPorter nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL IKONIC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon = {}
_addon.name = 'ChatPorter'
_addon.version = '1.12'
_addon.author = 'Ragnarok.Ikonic'

require 'tablehelper'
require 'stringhelper'
require 'colors'

LSname = get_player().linkshell;
playerName = get_player().name;
specialChar = "|";
lastTellFrom = "";

LScolor = 41; -- 41, 70, 158, 204
Pcolor = 207; -- 207
Tcolor = 200; -- 208

UseChatPorter = 1;
DisplayPartyChat = 1;
DisplayLinkshellChat = 1;
DisplayTellChat = 1;

chatPorterValues = T{};
chatPorterValues.UseChatPorter = T{};
chatPorterValues.UseChatPorter.name = "UseChatPorter";
chatPorterValues.UseChatPorter.value = true;
chatPorterValues.DisplayPartyChat = T{};
chatPorterValues.DisplayPartyChat.name = "DisplayPartyChat";
chatPorterValues.DisplayPartyChat.value = true;
chatPorterValues.DisplayLinkshellChat = T{};
chatPorterValues.DisplayLinkshellChat.name = "DisplayLinkshellChat";
chatPorterValues.DisplayLinkshellChat.value = true;
chatPorterValues.DisplayTellChat = T{};
chatPorterValues.DisplayTellChat.name = "DisplayTellChat";
chatPorterValues.DisplayTellChat.value = true;

function event_load()
	send_command('alias ChatPorter lua command ChatPorter')
	send_command('alias cp lua command ChatPorter')
	send_command('alias l2 lua command ChatPorter l')
	send_command('alias p2 lua command ChatPorter p')
	send_command('alias t2 lua command ChatPorter t')
	send_command('alias r2 lua command ChatPorter r')
	send_command('alias f1 lua command ChatPorter f1')
	send_command('alias f2 lua command ChatPorter f2')
	send_command('alias f3 lua command ChatPorter f3')
	send_command('alias f4 lua command ChatPorter f4')
	send_command('alias f5 lua command ChatPorter f5')
	add_to_chat(55, "Loading ".._addon.name.." v".._addon.version.." (written by ".._addon.author..")")
	event_addon_command('help');
	showStatus();
end

function event_unload()
	send_command('unalias ChatPorter')
	send_command('unalias cp')
	send_command('unalias l2')
	send_command('unalias p2')
	send_command('unalias t2')
	send_command('unalias r2')
	send_command('unalias f1')
	send_command('unalias f2')
	send_command('unalias f3')
	send_command('unalias f4')
	send_command('unalias f5')
	add_to_chat(55, "Unloading ".._addon.name.." v".._addon.version..".")
end

function event_login(name)
	LSname = get_player().linkshell;
	playerName = get_player().name;
--	add_to_chat(160,"Refreshing data...");
--	add_to_chat(160,"LSname: "..LSname);
--	add_to_chat(160,"playerName: "..playerName);
end

function event_addon_command(...)
    local args = {...}
    if args[2] ~= nil then
        comm = args[1]
		com2 = table.remove(args,1)
		com2 = table.concat(args, ' ')
		if comm:lower() == 'l' then
			send_ipc_message(specialChar.."l2:"..LSname..specialChar..playerName..specialChar..com2);
		elseif comm:lower() == 'p' then
			send_ipc_message(specialChar.."p2:"..""..specialChar..playerName..specialChar..com2);
		elseif comm:lower() == 't' then
			send_ipc_message(specialChar.."t2:"..playerName..specialChar..playerName..specialChar..com2);
		elseif comm:lower() == 'r' then
			send_ipc_message(specialChar.."r2:"..playerName..specialChar..playerName..specialChar..com2);
		elseif string.first(comm:lower(), 1) == 'f' then
			send_ipc_message(specialChar.."f:"..string.at(comm,2)..specialChar..playerName..specialChar..com2);
		end
    elseif args[1] ~= nil then
        comm = args[1]
        if comm:lower() == 'help' then
            add_to_chat(55,_addon.name.." v".._addon.version..' possible commands:')
			add_to_chat(55,'     //ChatPorter and //cp are both valid commands.')
            add_to_chat(55,'     //ChatPorter help   : Lists this menu.')
			add_to_chat(55,'     //ChatPorter status : Shows current configuration.')
            add_to_chat(55,'     //ChatPorter toggle : Toggles ChatPorter on/off.')
            add_to_chat(55,'     //ChatPorter p      : Toggles using ChatPorter for party chat.')
            add_to_chat(55,'     //ChatPorter l      : Toggles using ChatPorter for linkshell chat.')
            add_to_chat(55,'     //ChatPorter t      : Toggles using ChatPorter for tell chat.')
			add_to_chat(55,'     //l2 message        : Sends message from second character to linkshell.')
			add_to_chat(55,'     //p2 message        : Sends message from second character to party.')
			add_to_chat(55,'     //t2 name message   : Sends message from second character to name in tell.')
			add_to_chat(55,'     //r2 message        : Sends reply message from second character.')
			add_to_chat(55,'     //f# message        : Sends message from second character to FFOChat channel #.  Works for 1-5.')
			add_to_chat(55,'     //cp f# message     : Same as f#, but for any #.')
		elseif comm:lower() == 'status' then
            showStatus();
        elseif comm:lower() == 'toggle' then
			chatPorterValues.UseChatPorter.value = not chatPorterValues.UseChatPorter.value;
			showStatus(chatPorterValues.UseChatPorter);
        elseif comm:lower() == 'p' then
			chatPorterValues.DisplayPartyChat.value = not chatPorterValues.DisplayPartyChat.value;
			showStatus(chatPorterValues.DisplayPartyChat);
        elseif comm:lower() == 'l' then
			chatPorterValues.DisplayLinkshellChat.value = not chatPorterValues.DisplayLinkshellChat.value;
			showStatus(chatPorterValues.DisplayLinkshellChat);
        elseif comm:lower() == 't' then
			chatPorterValues.DisplayTellChat.value = not chatPorterValues.DisplayTellChat.value;
			showStatus(chatPorterValues.DisplayTellChat);
		elseif comm:lower() == 'reset' then
			add_to_chat(160, _addon.name.." v".._addon.version.." resetting stats.");
            reset();
        elseif comm:lower() == 'exit' then
			send_command('lua u ChatPorter')
        else
            return
        end
	else
		event_addon_command('help')
    end
end

function event_linkshell_change(linkshell)
	LSname = get_player().linkshell;
end

function showStatus(var)
	if (var ~= nul) then
		add_to_chat(160,var.name..": "..onOffPrint(var.value));
	else
		for i,v in pairsByKeys(chatPorterValues) do
			add_to_chat(160,chatPorterValues[i].name..": "..string.color(onOffPrint(chatPorterValues[i].value), 55, 160));
		end
	end
end

function onOffPrint(bleh)
	if (bleh ~= nul) then
		if (bleh == 1) or (bleh == true) then
			bleh = "ON";
		else
			bleh = "OFF";
		end
	else
		bleh = "OFF";
	end
	return bleh;
end

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then 
			return nil
		else
			return a[i], t[a[i]]
        end
	end
	return iter
end

function event_ipc_message(msg)
	if (chatPorterValues.UseChatPorter.value == true) then
		if (string.find(msg, "|(%w+):(%w*)|(%a+)|(.+)")) then
			a,b,chatMode,senderLSname,senderName,message = string.find(msg, "|(%w+):(%w*)|(%a+)|(.+)")
			if (chatMode == "t") and (chatPorterValues.DisplayTellChat.value == true) then
				if (playerName ~= senderName) then
					add_to_chat(Tcolor,"[t] "..senderName..">>"..senderLSname.." "..message);
				end
			elseif (chatMode == "p") and (chatPorterValues.DisplayPartyChat.value == true) then
				if (T(get_party()):with('name', senderName) == nil) then
					add_to_chat(Pcolor,"[p] ".."("..senderName..") "..message);
				end
			elseif (chatMode == "l") and (chatPorterValues.DisplayLinkshellChat.value == true) then
				if (senderLSname ~= LSname) then
					add_to_chat(LScolor,"["..senderLSname.."] <"..senderName.."> "..message);
				end
			elseif (chatMode == "l2") then
				send_command("input /l "..message);
			elseif (chatMode == "p2") then
				send_command("input /p "..message);
			elseif (chatMode == "t2") then
				send_command("input /t "..message);
			elseif (chatMode == "r2") then
				send_command("input /t "..lastTellFrom.." "..message);
			elseif (chatMode == "f") then
				send_command("input /"..senderLSname.." "..message);
			end
		end
	end
end

function event_incoming_text(original, modified, mode)
	if (playerName == nil) then
		playerName = get_player().name;
	end
	if (LSname == nil) then
		LSname = get_player().linkshell;
	end

	if (mode == 6) then -- linkshell (me)
		if (string.find(original, "<(%a+)> (.+)")) then
			a,b,player,message = string.find(original, "<(%a+)> (.+)")
			send_ipc_message(specialChar.."l:"..LSname..specialChar..player..specialChar..message);
		end
	
	elseif (mode == 5) then -- party (me)
		if (string.find(original, "%((%a+)%) (.+)")) then
			a,b,player,message = string.find(original, "%((%a+)%) (.+)")
			send_ipc_message(specialChar.."p:"..""..specialChar..player..specialChar..message);
		end

	elseif (mode == 4) then -- tell (out)
		if (string.find(original, ">>(%a+) : (.+)")) then
			a,b,player,message = string.find(original, ">>(%a+) : (.+)")
			send_ipc_message(specialChar.."t:"..player..specialChar..playerName..specialChar..message);
		end
	end
	
     --[[
         4: tell (out)
         12: tell (in)
         5: party (me)
         13: party (others)
         6: linkshell (me)
         14: linkshell (others)
     --]]
end

function event_chat_message(is_gm, mode, player, message)
--[[
3 = tell
4 = party
5 = linkshell

	|t:from|senderName|message
]]--

	if (mode == 3) then -- tell
		send_ipc_message(specialChar.."t:"..playerName..specialChar..player..specialChar..message);
	elseif (mode == 5) then -- linkshell
		send_ipc_message(specialChar.."l:"..LSname..specialChar..player..specialChar..message);
	elseif (mode == 4) then -- party
		send_ipc_message(specialChar.."p:"..""..specialChar..player..specialChar..message);
	end
end

--[[

possible port to ffochat LSchannel
save and read settings to settings.xml
ability to change color settings

]]--

