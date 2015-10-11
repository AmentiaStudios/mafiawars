AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("database/cl_database.lua");
AddCSLuaFile("database/items.lua");

include("shared.lua");
include("player.lua");
include ("database/database.lua");
include ("database/items.lua");

function GM:PlayerConnect(playername, adress)
  print("Player: " ..playername.. ", has joined the game.");
end

function GM:PlayerInitialSpawn(player)
  print("Player: " ..player:Nick().. ", has spawned.");
  player:SetGamemodeTeam(0);

end

function GM:PlayerSpawn(player)
  player:SetModel("models/player/group01/male_07.mdl");
  player:giveGamemodeWeapons();

end

function GM:PlayerAuthed(player, steamID, uinqueID)
  print("Player: " ..player:Nick().. ", has gotten authed.");
  player:databaseCheck();
end

function GM:PlayerDisconnected()

  player:databaseDisconnect();

end
