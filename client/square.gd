extends Area3D

class_name FieldSquare


@onready var mesh_instance_3d : MeshInstance3D= $MeshInstance3D

var unit : Unit3D = null

var attackable : bool
var sniping : bool
var summonable : bool


var chooseable : bool = false:
	set(v):
		chooseable = v
		if chooseable:
			(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = Color.YELLOW
			input_ray_pickable = true
		else:
			(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = Color.WHITE
			input_ray_pickable = false

func set_attack():
	if unit and attackable:
		(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = Color.GREEN
	else:
		(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = Color.WHITE

func set_unit(u : Unit3D):
	if unit:
		remove_child(unit)
	unit = u
	if unit:
		add_child(unit)



# Called when the node enters the scene tree for the first time.
func _ready():
#	(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

