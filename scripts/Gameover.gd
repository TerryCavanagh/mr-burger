extends Node2D

@onready var FadeLayer = get_node("UI").get_node("FadeLayer");

func _process(_delta):
	if Input.is_action_just_pressed("confirm"):
		startgame();

func startgame():
	FadeLayer.visible = true;
	await get_tree().create_timer(0.5).timeout
	GameGlobal.newgame();
	get_tree().change_scene_to_file("res://scenes/Platformer.tscn");
