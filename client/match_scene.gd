extends Node

@onready var hand : PlayerHand = %Hand
@onready var field : Field = $Node3D/Field

@onready var hud : Node3D = %HUD

@onready var camera_3d : Camera3D = %Camera3D

var drag_plane : Plane = Plane(Vector3(0,1,0),0.5)


# Called when the node enters the scene tree for the first time.
func _ready():
	_drag_tween = create_tween()
	_drag_tween.kill()
	for h in hand.hands:
		h.input_event.connect(on_hand_card_input_event)
		h.mouse_entered.connect(on_hand_card_mouse_entered)
		h.mouse_exited.connect(on_hand_card_mouse_exited)
	field.set_attack()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if _drag_card:
		var m := get_viewport().get_mouse_position()
		var dir := camera_3d.project_ray_normal(m)
		var hit_position = drag_plane.intersects_ray(camera_3d.position,dir)
		if hit_position:
			var pos := hit_position as Vector3
			pos.y += 0.0
			pos.z += 0.0
			if _drag_tween_remain > 0.0:
				_drag_card.set_drag_face(pos,_drag_tween_remain)
			else:
				_drag_card.front.global_position = pos
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				hand.set_all_ray_pickable(true)
				_drag_card.restore_face()
				_drag_card = null
				field.set_choice(Mechanics.Choice.NO_CHOICE)
				field.set_attack()
				


var _click : bool = false
var _playable : bool = true
var _drag_card : Card3D = null

const DRAG_TWEEN_DURATION = 0.3
var _drag_tween_remain : float
var _drag_tween : Tween = null

func on_hand_card_input_event(card : Card3D,_camera : Camera3D, event : InputEvent, _hit_position : Vector3):
	if _click:
		if event is InputEventMouseMotion:
			if _playable:
				_drag_card = card
				hand.set_all_ray_pickable(false)
				_drag_tween_remain = DRAG_TWEEN_DURATION
				_drag_tween.kill()
				_drag_tween = create_tween()
				_drag_tween.tween_property(self,"_drag_tween_remain",0.0,DRAG_TWEEN_DURATION)
				field.set_choice(Mechanics.Choice.FRIEND_OPEN_FIELD_ONE)

			_click = false
		else:
			if (event is InputEventMouseButton
					and event.button_index == MOUSE_BUTTON_LEFT
					and not event.pressed):
				_click = false
	else:
		if (event is InputEventMouseButton
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.pressed):
			_click = true

func on_hand_card_mouse_entered(card : Card3D):
	var pos := hand.hand_positions[hand.hands.find(card)]
	pos.y += 1.8
	
	card.zoom_up_face(hand.to_global(pos),2.0,-card.rotation,0.5)


func on_hand_card_mouse_exited(card : Card3D):
	if _drag_card == null:
		card.restore_face()

