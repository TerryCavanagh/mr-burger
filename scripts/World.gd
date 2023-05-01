extends Node

var levelgrid:Array = ["question", "question", "house", "question", "question", "question", "burger", "question", "question"];
var fog:Array = [true, true, false, true, true, true, false, true, true];

var playerposition:int;
var cursorposition:int;

func reset():
	generateopeninggrid();
	
func generateopeninggrid():
	var levellist:Array = ["beach", "beach", "forest", "forest", "factory", "factory", "dungeon"];
	levellist = Random.shuffle(levellist);
	
	levelgrid = [levellist.pop_back(), levellist.pop_back(), "house", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "burger", levellist.pop_back(), levellist.pop_back()];
	fog = [true, true, false, true, true, true, false, true, true];
	
	playerposition = 6;
	cursorposition = 6;
	clearfog(playerposition);
	
func clearfog(index):
	fog[index] = false;
	levelgrid[index] = "clear";
	clearfog_up(index);
	clearfog_down(index);
	clearfog_left(index);
	clearfog_right(index);

func clearfog_up(index):
	if index - 3 >= 0:
		fog[index - 3] = false;

func clearfog_down(index):
	if index + 3 < 9:
		fog[index + 3] = false;

func clearfog_left(index):
	if index - 1 >= 0:
		if (index - 1) % 3 != 2:
			fog[index - 1] = false;

func clearfog_right(index):
	if index + 1 < 9:
		if (index + 1) % 3 != 0:
			fog[index + 1] = false;
