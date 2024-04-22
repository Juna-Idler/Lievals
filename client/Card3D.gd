extends Node3D

class_name Card3D


signal input_event(card : Card3D,camera : Camera3D, event : InputEvent, position : Vector3)

signal mouse_entered(card : Card3D)
signal mouse_exited(card : Card3D)

@onready var sub_viewport : SubViewport = $SubViewport

@onready var front : MeshInstance3D = $Front
@onready var back : MeshInstance3D = $Back


@export var deck_card_id : int
@export var base_card_id : int
@export var cost : int
@export var attack : int
@export var hp : int
@export var extra : Dictionary

@export var playable : bool
@export var choice_type : ServerInterface.Choice
@export var target : Array


var _tween : Tween = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_tween = create_tween()
	_tween.kill()
	(front.material_override as StandardMaterial3D).albedo_texture = sub_viewport.get_texture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func initialize():
	pass


func set_ray_pickable(enable : bool):
	$Area3D.input_ray_pickable = enable


func zoom_up_face(point : Vector3,zoom : float,rot : Vector3,duration : float):
	_tween.kill()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.set_parallel()
	_tween.tween_property(front,"rotation",rot,duration)
	_tween.tween_property(front,"scale",Vector3.ONE * zoom,duration)
	_tween.tween_property(front,"global_position",point,duration)

func restore_face(duration : float = 0.3):
	_tween.kill()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.set_parallel()
	_tween.tween_property(front,"position",Vector3.ZERO,duration)
	_tween.tween_property(front,"scale",Vector3.ONE,duration)
	_tween.tween_property(front,"rotation",Vector3.ZERO,duration)

func set_drag_face(point : Vector3,duration : float):
	_tween.kill()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.set_parallel()
	var trans := Transform3D(Basis(Vector3(1,0,0),-PI/2),point)
	_tween.tween_property(front,"global_transform",trans,duration)


func _on_area_3d_input_event(camera, event, hit_position, _normal, _shape_idx):
	input_event.emit(self,camera,event,hit_position)

func _on_area_3d_mouse_entered():
	mouse_entered.emit(self)
	pass # Replace with function body.


func _on_area_3d_mouse_exited():
	mouse_exited.emit(self)
	pass # Replace with function body.
