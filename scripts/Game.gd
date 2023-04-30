extends Node

@onready var Main = get_parent();
@onready var UI = Main.get_node("UI");
@onready var LevelNode = Main.get_node("Level");
@onready var Player = Main.get_node("Platformer_Player");

var hearts:Array = [];

var levels:Dictionary = {};
var currentlevel = "";

var lives:int = 3;
var score:int = 0;

func _ready():
	init();
	initUI();
	updateUI();
	
	preloadlevels();
	loadlevel("mainlevel");
	
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
			
func loadlevel(newlevel):
	unloadlevel();
	currentlevel = newlevel;
	LevelNode.add_child(levels[currentlevel].instantiate());

func unloadlevel():
	if(LevelNode.has_node("Level")):
		LevelNode.remove_child(LevelNode.get_node("Level"));

func init():
	score = 0;
	
func initUI():
	hearts.push_back(UI.get_node("life1"));
	hearts.push_back(UI.get_node("life2"));
	hearts.push_back(UI.get_node("life3"));
	hearts.push_back(UI.get_node("life4"));
	hearts.push_back(UI.get_node("life5"));
	
	for life in hearts:
		life.visible = false;
	
func updateUI():
	UI.get_node("Score").text = str(score);
	
	for life in hearts:
		life.visible = false;
	
	var i:int = 0;
	while i < lives:
		hearts[i].visible = true;
		i += 1;

func cuttoblack():
	UI.get_node("FadeLayer").visible = true;

func cuttowhite():
	UI.get_node("FadeLayer").visible = false;

func revive():
	get_tree().call_group("disapperingplatform", "reset");
