local player = FindMetaTable("Player");
local teams = {};
teams[0] = {
  name    = "Blue",
  color   = Vector( .2, .2, 1.0),
  weapons = {
    "weapon_crowbar",
    "weapon_pistol"
  }
};

teams[1] = {
  name    = "Red",
  color   = Vector( 1.0, .2, .2),
  weapons = {
    "weapon_crowbar",
    "weapon_pistol"
  }
};

function player:SetGamemodeTeam(team)

  if not teams[team] then return end

  self:SetTeam(team);
  self.SetPlayerColor(teams[team].color);
  self:giveGamemodeWeapons();

  return true;

end

function player:giveGamemodeWeapons()

  local team = self:Team();

  self:StripWeapons();

  for i, weapon in pairs(teams[team].weapons) do
    self:Give(weapon);
  end

end
