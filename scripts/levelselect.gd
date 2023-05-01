extends Node2D

@onready var UI = get_node("UI");
@onready var levelgrid = [
	UI.get_node("x0y0"),
	UI.get_node("x1y0"),
	UI.get_node("x2y0"),
	UI.get_node("x0y1"),
	UI.get_node("x1y1"),
	UI.get_node("x2y1"),
	UI.get_node("x0y2"),
	UI.get_node("x1y2"),
	UI.get_node("x2y2")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for l in levelgrid:
		l.play("forest");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
