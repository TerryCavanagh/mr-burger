extends Resource
class_name EnemyParameters

@export_enum("bug", "cog", "crab", "face", "fish", "scorpion", "slime") var sprite = "slime";
@export_enum("left", "right", "up", "down", "nothing") var behaviour = "left";
@export var speed:int = 1;
@export var movementrange:int = 5;

@export_subgroup("Advanced")
@export_enum("pink", "red", "white", "yellow") var colour = "pink";
@export var waitdelayframes:float = 15;
@export var starting_offset:int = 0;
@export var xoffset:int = 0;
@export var yoffset:int = 0;
