extends Node2D

@onready var FadeLayer = get_node("UI").get_node("FadeLayer");

func _ready():
	startgame();

func _process(_delta):
	pass
	#if Input.is_action_just_pressed("confirm"):
	#	startgame();

func startgame():
	FadeLayer.visible = true;
	World.preloadlevels();
	World.preloadentities();
	#await get_tree().create_timer(0.5).timeout
	GameGlobal.newgame();
	
	if BuildConfig.TESTLEVEL:
		World.nextstage = BuildConfig.testlevelstage;
		World.nextlevel = BuildConfig.testlevellevel;
	
	get_tree().change_scene_to_file("res://scenes/Platformer.tscn");
	#get_tree().change_scene_to_file("res://scenes/level_select.tscn");
