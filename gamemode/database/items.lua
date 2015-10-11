local items = {};

function getItems(name)

  if items[name] then
    return items[name];
  end
  return false;

end

items["soda1"] = {

  name = "Banta",
  desc = "Best of all!",
  ent = "item_basic",
  prices = {
    buy = 18,
    sell = 9,
  },
  model = "models/props_junk/PopCan01a.mdl",
  use = (function(player, ent)
          if player:isValid() then
              player:AddHealth(2);
              if ent then
                ent:Remove();
              end
            end
          end
  ),
  spawn = (function (player, ent)
            ent:SetItemName("Soda")
          end
  ),
  skin = 0,
  buttonDist = 32,
};

items["soda2"] = {

  name = "Spriti",
  desc = "Best of all too!",
  ent = "item_basic",
  prices = {
    buy = 18,
    sell = 9,
  },
  model = "models/props_junk/PopCan01a.mdl",
  use = (function(player, ent)
          if player:isValid() then
              player:AddHealth(2);
              if ent then
                ent:Remove();
              end
            end
          end
  ),
  spawn = (function (player, ent)
            ent:SetItemName("Soda")
          end
  ),
  skin = 1,
  buttonDist = 32,
};

items["soda2"] = {

  name = "Coba",
  desc = "Best of all too too!",
  ent = "item_basic",
  prices = {
    buy = 18,
    sell = 9,
  },
  model = "models/props_junk/PopCan01a.mdl",
  use = (function(player, ent)
          if player:isValid() then
              player:AddHealth(2);
              if ent then
                ent:Remove();
              end
            end
          end
  ),
  spawn = (function (player, ent)
            ent:SetItemName("Soda")
          end
  ),
  skin = 2,
  buttonDist = 32,
};
