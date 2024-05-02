extends Node3D

class_name PlayerHand

signal hand_card_input_event(card : Card3D,_camera : Camera3D, event : InputEvent, _hit_position : Vector3)
signal hand_card_mouse_entered(card : Card3D)
signal hand_card_mouse_exited(card : Card3D)


@export var hands : Array[Card3D]

@onready var path_3d : Path3D = $Path3D

const CARD_3D = preload("res://client/card3d.tscn")


var hand_positions : Array[Vector3]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_cards(cards : Array[Card3D],duration : float):
	var tween := create_tween()
	tween.set_parallel()
	hands = cards
	set_all_ray_pickable(false)
	hand_positions.resize(hands.size())
	if hands.size() < 5:
		for i in hands.size():
			var p := Vector3(-2 + i,0,0)
			var card := hands[i]
			card.reparent(self)
			p.z = (i + 1) * 0.01
			tween.tween_property(card,"position",p,duration)
			tween.tween_property(card,"scale",Vector3.ONE,duration)
			hand_positions[i] = p
	else:
		for i in hands.size():
			var rate := float(i) / (hands.size()-1)
			var p := path_3d.curve.samplef(lerpf(0,path_3d.curve.point_count - 1,rate))
			var card := hands[i]
			card.reparent(self)
			p.z = (i + 1) * 0.01
			tween.tween_property(card,"position",p,duration)
			tween.tween_property(card,"rotation_degrees:z",lerpf(15,-15,rate),duration)
			tween.tween_property(card,"scale",Vector3.ONE,duration)
			hand_positions[i] = p

	for c in hands:
		c.input_event.connect(on_hand_card_input_event)
		c.mouse_entered.connect(on_hand_card_mouse_entered)
		c.mouse_exited.connect(on_hand_card_mouse_exited)
	
	await tween.finished
	set_all_ray_pickable(true)

func reset_cards(cards : Array[Card3D]):
	hands = cards
	set_all_ray_pickable(false)
	hand_positions.resize(hands.size())
	if hands.size() < 5:
		for i in hands.size():
			var p := Vector3(-2 + i,0,0)
			var card := hands[i]
			card.reparent(self)
			p.z = (i + 1) * 0.01
			card.position = p
			card.scale = Vector3.ONE
			hand_positions[i] = p
	else:
		for i in hands.size():
			var rate := float(i) / (hands.size()-1)
			var p := path_3d.curve.samplef(lerpf(0,path_3d.curve.point_count - 1,rate))
			var card := hands[i]
			card.reparent(self)
			p.z = (i + 1) * 0.01
			card.position = p
			card.rotation_degrees.z = lerpf(15,-15,rate)
			card.scale = Vector3.ONE
			hand_positions[i] = p

	for c in hands:
		c.input_event.connect(on_hand_card_input_event)
		c.mouse_entered.connect(on_hand_card_mouse_entered)
		c.mouse_exited.connect(on_hand_card_mouse_exited)
	
	set_all_ray_pickable(true)
	

func on_hand_card_input_event(card : Card3D,camera : Camera3D, event : InputEvent, hit_position : Vector3):
	hand_card_input_event.emit(card,camera,event,hit_position)
	
func on_hand_card_mouse_entered(card : Card3D):
	hand_card_mouse_entered.emit(card)

func on_hand_card_mouse_exited(card : Card3D):
	hand_card_mouse_exited.emit(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_all_ray_pickable(pickable : bool):
	for h in hands:
		h.set_ray_pickable(pickable)

