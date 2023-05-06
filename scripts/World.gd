extends Node

var nextstage:String;
var nextlevel:String;
var levels:Dictionary = {};

var levelgrid:Array = ["question", "question", "delivery", "question", "question", "question", "burger", "question", "question"];
var fog:Array = [true, true, false, true, true, true, false, true, true];

var playerposition:int;
var cursorposition:int;

var placementstage:Array = [];
var placementposition:Array = [];

func reset():
	nextstage = "burger";
	nextlevel = "stage1";
	
	placementstage = [];
	placementposition = [];
	
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

#Place a burger at the furtherest corner. Let's make this
#more interesting later
func generateburger():
	var newplacementstage = "burger";
	var newplacementposition = playerposition;
	match playerposition:
		0:
			newplacementposition = 8;
		2:
			newplacementposition = 6;
		6:
			newplacementposition = 2;
		8:
			newplacementposition = 0;
	
	placementstage.push_back(newplacementstage);
	placementposition.push_back(newplacementposition);
	
func generatedelivery():
	var newplacementstage = "delivery";
	var newplacementposition = playerposition;
	match playerposition:
		0:
			newplacementposition = 8;
		2:
			newplacementposition = 6;
		6:
			newplacementposition = 2;
		8:
			newplacementposition = 0;
	
	placementstage.push_back(newplacementstage);
	placementposition.push_back(newplacementposition);

#Add a randomlevel to the placement queue
func placerandomstage():
	var emptyspots:Array = [];
	var i = 0;
	while i < levelgrid.size():
		if levelgrid[i] == "clear" and playerposition != i and !placementposition.has(i):
			emptyspots.push_back(i);
		i += 1;
	
	if emptyspots.size() > 0:
		var levellist:Array = ["beach", "beach", "forest", "forest", "factory", "factory", "dungeon"];
		levellist = Random.shuffle(levellist);
		
		var newplacementstage = levellist.pop_back();
		var newplacementposition = emptyspots.pop_back();
		
		placementstage.push_back(newplacementstage);
		placementposition.push_back(newplacementposition);

func clearplacements():
	placementstage = [];
	placementposition = [];

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
