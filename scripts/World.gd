extends Node

var nextstage:String;
var nextlevel:String;
var levels:Dictionary = {};

var levelgrid:Array = ["question", "question", "delivery", "question", "question", "question", "burger", "question", "question"];
var fog:Array = [true, true, false, true, true, true, false, true, true];

var playerposition:int;
var cursorposition:int;

func reset():
	nextstage = "mrburger";
	nextlevel = "stage1";
	
	generateopeninggrid();

func preloadlevels():
	var dir = DirAccess.open("levels/");
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var levelname = file_name.split(".")[0];
				levels[levelname] = load("res://levels/" + file_name);
			file_name = dir.get_next()

func generateopeninggrid():
	var levellist:Array = ["beach", "beach", "forest", "forest", "factory", "factory", "dungeon"];
	levellist = Random.shuffle(levellist);
	
	var randint:int = Random.integer(0, 4);
	match randint:
		0:
			levelgrid = [levellist.pop_back(), levellist.pop_back(), "delivery", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "burger", levellist.pop_back(), levellist.pop_back()];
			fog = [true, true, false, true, true, true, false, true, true];
			playerposition = 6;
		1:
			levelgrid = ["burger", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "delivery"];
			fog = [false, true, true, true, true, true, true, true, false];
			playerposition = 0;
		2:
			levelgrid = [levellist.pop_back(), levellist.pop_back(), "burger", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "delivery", levellist.pop_back(), levellist.pop_back()];
			fog = [true, true, false, true, true, true, false, true, true];
			playerposition = 2;
		3:
			levelgrid = ["delivery", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "burger"];
			fog = [false, true, true, true, true, true, true, true, false];
			playerposition = 8;
			
	cursorposition = playerposition;
	#clearfog(playerposition);
	#actually nevermind, fog sucks
	fog = [false, false, false, false, false, false, false, false, false];
	
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
