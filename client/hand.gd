extends Node3D

class_name PlayerHand


@export var hands : Array[Card3D]

@onready var path_3d : Path3D = $Path3D

const CARD_3D = preload("res://client/Card3D.tscn")


var hand_positions : Array[Vector3]

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_positions.resize(hands.size())
	if hands.size() < 5:
		for i in hands.size():
			var p := Vector3(-2 + i,0,0)
			var card := CARD_3D.instantiate()
			add_child(card)
			hands[i] = card
			p.z = (i + 1) * 0.01
			card.position = p
			hand_positions[i] = p
	else:
		for i in hands.size():
			var rate := float(i) / (hands.size()-1)
			var p := path_3d.curve.samplef(lerpf(0,path_3d.curve.point_count - 1,rate))
			var card := CARD_3D.instantiate()
			add_child(card)
			hands[i] = card
			p.z = (i + 1) * 0.01
			card.position = p
			card.rotation_degrees.z = lerpf(15,-15,rate)
			hand_positions[i] = p

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_all_ray_pickable(pickable : bool):
	for h in hands:
		h.set_ray_pickable(pickable)

