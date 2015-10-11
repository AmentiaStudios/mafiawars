local database = {};

local function databaseReceive(table)
  database = table;
end

net.Receive("database", function(len)
  local table = net.ReadTable();
  databaseReceive(table);

end);

function databaseTable()
  return database;
end

function databaseGetValue(name)
  local database = databaseTable();
  return database[name];
end

function inventoryTable()
  return databaseGetValue("inventory") or {}
end

function inventoryHasItem(name, amount)

  if not amount then amount = 1 end

  local invento = inventoryTable();

  if invento then
    if invento[name] then
      if invento[name].amount >= amount then
        return true;
      else
        return false;
      end
    else
      return false;
    end
  else
    return false;
  end
end

local SKINS = {};
SKINS.COLORS = {
    lightgrey = Color(131, 131, 131, 180),
    grey = Color(111, 111, 111, 180),
    lowWhite = Color(243, 243, 243, 180),
    goodBlack = Color(41, 41, 41, 230),
};

function SKINS:DrawFrame(w, h)

  topHeight = 24;
  local rounded = 4;
  draw.RoundedBoxEx(rounded, 0, 0, w, topHeight, SKINS.COLORS.lightgrey, true, true, false, false);
  draw.RoundedBoxEx(rounded, 0, topHeight, w, h-topHeight, SKINS.COLORS.lightgrey, false, false, true, true);
  draw.RoundedBoxEx(rounded, 2, topHeight, w-4, h-topHeight-2, SKINS.COLORS.goodBlack, false, false, true, true);

  local QuadTable = {};
  QuadTable.texture = surface.GetTextureID("gui/gradient");
  QuadTable.color = Color(10, 10, 10, 120);
  QuadTable.x = 2;
  QuadTable.y = topHeight;
  QuadTable.w = w - 4;
  QuadTable.h = h-topHeight-2;

  draw.TexturedQuad(QuadTable);

end

local function inventoryItemButton(iname, name, amount, desc, model, parent, dist, buttons)

  if not dist then dist = 128 end
  local p = vgui.Create("DPanel", parent);
  p:SetPos(4, 4);
  p:SetSize(64, 64);

  local mp = vgui.Create("DModelPanel", p);
  mp:SetSize(p:GetWide(), p:GetTall());
  mp:SetPos(0,0);
  mp:SetModel(model);
  mp:SetAnimSpeed(0.1);
  mp:SetAnimated(true);
  mp:SetAmbientLight(Color(50, 50, 50));
  mp:SetDirectionalLight(BOX_TOP, Color(255, 255, 255));
  mp:SetCamPos(Vector(dist, dist, dist));
  mp:SetLookAt(Vector(0, 0, 0));
  mp:SetFOV(20);

  function mp:layoutEntity(Entity)

    self:RunAnimation();
    Entity:SetSkin(getItems(iname).skin or 0);
    Entity:SetAngles(Angle(0,0,0));
  end

  local button = vgui.Create("DButton", p);
  button:SetPos(4,4);
  button:SetSize(64, 64);
  button:SetText("");
  button:SetToolTip(name .. ":\n\n" .. desc);

  button.DoClick = function()
    local opt = DermaMenu();
    for i, v in pairs(buttons) do
      opt:AddOption(k, v);
    end
    opt:Open();
  end

  button.DoRightClick = function()
  end

  function button.Paint()
    return true;
  end

  if amount then
    local lable = vgui.Create("DLabel", p);
    lable:SetPos(6, 4);
    lable:SetFont("default");
    lable:SetText(amount);
    lable:SizeToContents();
  end

  return p;

end

function inventoryMenu()

  local w = 506;
  local h = 512;

  local frame = vgui.Create("DFrame");
  frame:SetSize(w, h);
  frame:SetPos((ScrW()/2) - (w/2), (ScrH()/2) - (h/2));
  frame:SetTitle("inventory");
  frame:SetDraggable(true);
  frame:ShowCloseButton(true);
  frame:MakePopup();
  frame.Paint = function()
    SKINS:DrawFrame(frame:GetWide(), frame:GetTall());
  end

  local ps = vgui.Create("DPropertySheet", f);
  ps:SetPos(8, 28);
  ps:SetSize(w - 16, h - 36);

  local padding = 4;

  local items = vgui.Create("DPanelList", ps);
  items:SetPos(padding, padding);
  items:SetSize(w - 32 - padding*2, h - 48 - padding*2);
  items:EnableVerticalScrollbar(true);
  items:EnableHorizontal(true);
  items:SetPadding(padding);
  items:SetSpacing(padding);

  function items:Paint()
    draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60));
  end

  local inventory = inventoryTable();

  local function ItemButtons()
    for i, v in pairs(inventory) do
      local item = getItems(i);

      if item then
        local buttons = {};

        buttons["use"] = (function()
          frame:Close();
        end);

        buttons["drop"] = (function()
          frame:Close();
        end);

        local b = inventoryItemButton(i, item.name .. "(" .. v.amount .. ")", v.amount, item.desc, item.model, items, item.buttonDist, buttons);

        items:AddItem(b);
      end
    end
  end

  ItemButtons();
  ps:AddSheet("Items", items, "icon16/box.png", false, false, "Your items are here");

end

concommand.Add("inventory", inventoryMenu);
