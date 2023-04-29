extends Node

@onready var Main = get_parent();
@onready var UI = Main.get_node("UI");

var score:int = 0;

func _ready():
	init();
	updateUI();
	
func init():
	score = 0;
	
func updateUI():
	UI.get_node("Score").text = str(score);

func cuttoblack():
	UI.get_node("FadeLayer").visible = true;

func cuttowhite():
	UI.get_node("FadeLayer").visible = false;
