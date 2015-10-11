GM.Name = "Mafia Wars";
GM.Author ="flaver";
GM.Email = "N/A";
GM.Website = "N/A";

team.SetUp(0, "Blue", Color(0,0,225));
team.SetUp(1, "Red", Color(225,0,0));

function GM:Initialize()

  self.BaseClass.Initialize(self);

end
