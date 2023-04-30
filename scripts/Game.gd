extends Node

@onready var Main = get_parent();
@onready var UI = Main.get_node("UI");
@onready var LevelNode = Main.get_node("Level");
@onready var Player = Main.get_node("Platformer_Player");

var hearts:Array = [];
var keygfx:Array = [];

var levels:Dictionary = {};
var currentlevel = "";

var lives:int = 3;
var keys:int = 0;
var score:int = 0;

func _ready():
	init();
	initUI();
	updateUI();
	
	preloadlevels();
	#loadlevel("factory", "stage1");
	loadlevel("dungeon", "stage1");
	#loadlevel("forest", "stage1");
	#loadlevel("beach", "stage1");
	#loadlevel("testlevel", "testlevel")
	
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
			
func loadlevel(stage, newlevel):
	unloadlevel();
	currentlevel = newlevel;
	var version:String = "a";
	LevelNode.add_child(levels[stage + "_" + currentlevel + "_" + version].instantiate());

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
	
	keygfx.push_back(UI.get_node("key1"));
	keygfx.push_back(UI.get_node("key2"));
	keygfx.push_back(UI.get_node("key3"));
	keygfx.push_back(UI.get_node("key4"));
	keygfx.push_back(UI.get_node("key5"));
	
	for k in keygfx:
		k.visible = false;
	
func updateUI():
	UI.get_node("Score").text = str(score);
	
	for life in hearts:
		life.visible = false;
	
	var i:int = 0;
	while i < lives:
		if i < 5:
			hearts[i].visible = true;
		i += 1;
	
	for k in keygfx:
		k.visible = false;
	
	var j:int = 0;
	while j < keys:
		if j < 5:
			keygfx[j].visible = true;
		j += 1;

func cuttoblack():
	UI.get_node("FadeLayer").visible = true;

func cuttowhite():
	UI.get_node("FadeLayer").visible = false;

func revive():
	get_tree().call_group("disapperingplatform", "reset");
