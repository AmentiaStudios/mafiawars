local player = FindMetaTable("Player");
util.AddNetworkString("database");

function player:ShortSteamId()

  local id = self:SteamID();
  local id = tostring(id);
  local id = string.Replace(id, "STEAM_0:0:", "");
  local id = string.Replace(id, "STEAM_0:1:", "");

  return id;

end

local oldPrint = print;

local function print(s)
  oldPrint("database.lua: " .. s);
end

function player:databaseDefault()

  self:databaseSetValue("money", 100);
  self:databaseSetValue("xp", 0);
  self:databaseSetValue("hunger", 0);

  local i = {};
  i["soda1"] = {amount = 10};
  i["soda2"] = {amount = 10};

  self:databaseSetValue("inventory", i);

end

function player:databaseNetworkData()

  local money = self:databaseGetValue("money");
  local xp = self:databaseGetValue("xp");
  local hunger = self:databaseGetValue("hunger");

  self:SetNWInt("money", money);
  self:SetNWInt("xp", xp);
  self:SetNWInt("hunger", hunger);

  self:KillSilent();
  self:Spawn();

end

function player:databaseFolders()
  return "server/mafiawars/players/" .. self:ShortSteamId() .. "/";
end

function player:databasePath()
  return self:databaseFolders() .. "database.txt";
end

function player:databaseSet(tab)
  self.database = tab;
end

function player:databaseGet()
  return self.database;
end

function player:databaseCheck()

  self.database = {};
  local f = self:databaseExists();

  if f then
    self:databaseRead();
  else
    self:databaseCreate();
  end

  self:databaseSend();
  self:databaseNetworkData();

end

function player:databaseSend()

  net.Start("database");
  net.WriteTable(self:databaseGet());
  net.Send(self);

end

function player:databaseExists()
  local file = file.Exists(self:databasePath(), "DATA");
  return file;
end

function player:databaseRead()
  local str = file.Read(self:databasePath(), "DATA");
  self:databaseSet(util.KeyValuesToTable(str));
end

function player:databaseSave()

  local str = util.TableToKeyValues(self.database);
  local file = file.Write(self:databasePath(), str);
  self:databaseSend();

end

function player:databaseCreate()
  self:databaseDefault();
  local folder = file.CreateDir(self:databaseFolders());
  self:databaseSave();
end

function player:databaseDisconnect()
  self:databaseSave();
end

function player:databaseSetValue(name, value)

  if not value then return end

  if type(value) == "table" then
    if name == "inventory" then
      for i, item in pairs(value) do
        if item.amount <= 0 then
          value[i] = nil;
        end
      end
    end
  end

  local database = self:databaseGet();
  database[name] = value;

  self:databaseSave();

end

function player:databaseGetValue(name)

  local database = self:databaseGet();
  return database[name];

end

function GM:ShowHelp(player)

  player:ConCommand("inventory");

end
