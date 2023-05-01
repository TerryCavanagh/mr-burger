extends Node

@onready var Main = get_parent();
@onready var UI = Main.get_node("UI");
@onready var LevelNode = Main.get_node("Level");
@onready var Player = Main.get_node("Platformer_Player");

var hearts:Array = [];
var keygfx:Array = [];

var currentlevel = "";

var preventmovement:bool = false;

var messagetime:float = 0.0;

func _ready():
	init();
	initUI();
	updateUI();
	
	loadlevel(World.nextstage, World.nextlevel);
	
func _process(delta):
	if messagetime > 0:
		messagetime -= delta;
		if messagetime <= 0:
			messagetime = 0;
			hidemessage();
		else:
			if Input.is_action_just_pressed("confirm"):
				messagetime = 0;
				hidemessage();

func loadlevel(stage, newlevel):
	unloadlevel();
	currentlevel = newlevel;
	var version:String = "a";
	LevelNode.add_child(World.levels[stage + "_" + currentlevel + "_" + version].instantiate());

func unloadlevel():
	if(LevelNode.has_node("Level")):
		LevelNode.remove_child(LevelNode.get_node("Level"));

func init():
	GameGlobal.newgame();
	World.reset();
	preventmovement = false;
	
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
	UI.get_node("Score").text = str(GameGlobal.score);
	
	for life in hearts:
		life.visible = false;
	
	var i:int = 0;
	while i < GameGlobal.lives:
		if i < 5:
			hearts[i].visible = true;
		i += 1;
	
	for k in keygfx:
		k.visible = false;
	
	var j:int = 0;
	while j < GameGlobal.keys:
		if j < 5:
			keygfx[j].visible = true;
		j += 1;

func cuttoblack():
	UI.get_node("FadeLayer").visible = true;

func cuttowhite():
	UI.get_node("FadeLayer").visible = false;

func revive():
	get_tree().call_group("disapperingplatform", "reset");
	
func showmessage(msg:String):
	UI.get_node("Message").get_node("Text").text = msg;
	UI.get_node("Message").visible = true;
	
	messagetime = 2.0;

func hidemessage():
	preventmovement = false;
	UI.get_node("Message").visible = false;
	

