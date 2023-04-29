extends Node2D

@export var timer:float = 0.0;
@export var onrate:float = 2.0;
@export var offrate:float = 2.0;
@export var start_on:bool = true;

var enabled:bool;

func _ready():
	enabled = true;
	if !start_on:
		disable();

func _process(delta):
	timer += delta;
	
	if enabled:
		if timer >= onrate:
			timer -= onrate;
			disable();
	else:
		if timer >= offrate:
			timer -= offrate;
			enable();

func enable():
	$AnimatedSprite2D.play("default");
	$AnimatedSprite2D2.play("default");
	enabled = true;

func disable():
	$AnimatedSprite2D.play("inactive");
	$AnimatedSprite2D2.play("inactive");
	enabled = false;

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if enabled:
			body.killplayer();
			await get_tree().create_timer(1.0).timeout
			queue_free();
