extends Node

var nextstage:String;
var nextlevel:String;
var levels:Dictionary = {};

var levelgrid:Array[String] = [];
const WIDTH:int = 4;
const HEIGHT:int = 4;

var playerposition:Vector2i;
var cursorposition:Vector2i;

var placementstage:Array[String] = [];
var placementposition:Array[Vector2i] = [];

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
	var levellist:Array = [
		"beach", "beach", "beach", "beach", 
		"forest", "forest", "forest", "forest", 
		"factory", "factory", "factory", "factory", 
		"dungeon", "dungeon"
		];
	levellist = Random.shuffle(levellist);
	
	var randint:int = Random.integer(0, 4);
	randint = 0; #with a 4x4 grid, I think a consistent layout works better
	match randint:
		0:
			levelgrid = [
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "delivery",
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				"burger", levellist.pop_back(), levellist.pop_back(), levellist.pop_back()];
			playerposition = Vector2i(0, HEIGHT - 1);
		1:
			levelgrid = [
				"burger", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "delivery"];
			playerposition = Vector2i(0, 0);
		2:
			levelgrid = [
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "burger",
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				"delivery", levellist.pop_back(), levellist.pop_back(), levellist.pop_back()];
			playerposition = Vector2i(WIDTH - 1, 0);
		3:
			levelgrid = [
				"delivery", levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), levellist.pop_back(),
				levellist.pop_back(), levellist.pop_back(), levellist.pop_back(), "burger"];
			playerposition = Vector2i(WIDTH - 1, HEIGHT - 1);
	
	cursorposition = playerposition;
	
#Place a burger at the furtherest corner. Let's make this
#more interesting later
func generateburger():
	var newplacementstage = "burger";
	var newplacementposition:Vector2i = playerposition;
	newplacementposition.x = (WIDTH - 1) - playerposition.x;
	newplacementposition.y = (HEIGHT - 1) - playerposition.y;
	placementstage.push_back(newplacementstage);
	placementposition.push_back(newplacementposition);
	
func generatedelivery():
	var newplacementstage = "delivery";
	var newplacementposition:Vector2i = playerposition;
	newplacementposition.x = (WIDTH - 1) - playerposition.x;
	newplacementposition.y = (HEIGHT - 1) - playerposition.y;
	placementstage.push_back(newplacementstage);
	placementposition.push_back(newplacementposition);

func gridindex(v:Vector2i) -> int:
	return v.x + (v.y * WIDTH);
	
func getvectorfromindex(index:int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(index % WIDTH, (index - (index % WIDTH)) / HEIGHT);
	
#Add a randomlevel to the placement queue
func placerandomstage():
	var emptyspots:Array[Vector2i] = [];
	
	var j:int = 0;
	while j < HEIGHT:
		var i:int = 0;
		while i < WIDTH:
			var pos:Vector2i = Vector2i(i, j);
			if levelgrid[i + (j * WIDTH)] == "clear" and playerposition != pos and !placementposition.has(pos):
				emptyspots.push_back(pos);
			i += 1;
		j += 1;
	
	if emptyspots.size() > 0:
		var levellist:Array = ["beach", "beach", "forest", "forest", "factory", "factory", "dungeon"];
		levellist = Random.shuffle(levellist);
		
		var newplacementstage = levellist.pop_back();
		var newplacementposition = emptyspots.pop_back();
		
		placementstage.push_back(newplacementstage);
		placementposition.push_back(newplacementposition);

func decaywall():
	for i in range(levelgrid.size()):
		if levelgrid[i] == "wall_old":
			placementstage.push_back("clear");
			placementposition.push_back(getvectorfromindex(i));
		elif levelgrid[i] == "wall_new":
			levelgrid[i] = "wall_old";

func indexisadjacenttodestination(index) -> bool:
	#Because we're always using a 4x4 grid and we always have the destinations
	#in the same places, we can just hard code some indexs to exclude
	if index == 2:
		return true;
	if index == 13:
		return true;
	#These two are the vertically adjacent squares - you could turn this off
	#and it would be fine, but these are bad wall positions so let's try it this way
	if index == 7:
		return true;
	if index == 8:
		return true;
	return false;

#Similar to "place random stage", but check that you don't block off access
#by having some excluded points
func placewall():
	var emptyspots:Array[Vector2i] = [];
	
	var j:int = 0;
	while j < HEIGHT:
		var i:int = 0;
		while i < WIDTH:
			var pos:Vector2i = Vector2i(i, j);
			if levelgrid[i + (j * WIDTH)] == "clear" and playerposition != pos and !placementposition.has(pos):
				if not indexisadjacenttodestination(i + (j * WIDTH)): #exclude points beside destinations to prevent blocked paths
					emptyspots.push_back(pos);
			i += 1;
		j += 1;
	
	if emptyspots.size() > 0:
		var newplacementstage = "wall_new";
		var newplacementposition = emptyspots.pop_back();
		
		placementstage.push_back(newplacementstage);
		placementposition.push_back(newplacementposition);

func clearplacements():
	placementstage = [];
	placementposition = [];
	
func stageat(v:Vector2i) -> String:
	var returnvalue:String = "wall";
	if v.x >= 0 and v.x < WIDTH:
		if v.y >= 0 and v.y < HEIGHT:
			returnvalue = levelgrid[gridindex(v)];
	
	if S.isinstring(returnvalue, "_"):
		returnvalue = S.getroot(returnvalue, "_");
	
	return returnvalue;
