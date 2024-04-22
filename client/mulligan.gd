extends Node3D

class_name Mulligan


signal decided

@onready var control = $Control
@onready var first_second = $Control/FirstSecond

const EXCHANGE = preload("res://client/exchange.tscn")

var cards : Array[Card3D]
var exchanges : Array[TextureRect]

var tween : Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	control.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func start_async(first : bool,dealt_cards : Array[Card3D],duration : float):
	if first:
		first_second.text = "先攻"
	else:
		first_second.text = "後攻"
	
	cards = dealt_cards
	exchanges.clear()
	for c in cards:
		c.position = Vector3(-4,0,0)
		c.rotation_degrees = Vector3(0,180,0)
		add_child(c)
		c.input_event.connect(on_card_input_event)
		
	tween = create_tween()
	tween.set_parallel()
	var left = (cards.size() - 1.0) / 2.0 * -0.9
	for i in cards.size():
		var target_pos := Vector3(left + 0.9 * i,0,0)
		tween.tween_property(cards[i],"position",target_pos,duration)
		
		var exc := EXCHANGE.instantiate()
		exc.visible = false
		control.add_child(exc)
		var pos := get_viewport().get_camera_3d().unproject_position(global_position + target_pos)
		pos -= Vector2(112,112)
		exc.position = pos
		exchanges.append(exc)
	tween.set_parallel(false)
	tween.tween_interval(0.2)
	tween.tween_interval(0.0)
	tween.set_parallel(true)
	for i in cards.size():
		tween.tween_property(cards[i],"rotation",Vector3(0,0,0),duration)
	await tween.finished
	control.show()

func wait_async() -> Array[int]:
	await decided
	var result : Array[int] = []
	for i in exchanges.size():
		if exchanges[i].visible:
			result.append(i)
		exchanges[i].visible = false
	if not result.is_empty():
		tween = create_tween()
		tween.set_parallel()
		for i in result:
			tween.tween_property(cards[i],"position",Vector3(-4,-3,0),0.5)
		tween.set_parallel(false)
		for i in result:
			tween.tween_property(cards[i],"rotation_degrees",Vector3(0,180,0),0.0)
		
	return result

func end_async():
	if tween.is_running():
		await tween.finished
	tween = create_tween()
	tween.set_parallel()
	var left = (cards.size() - 1.0) / 2.0 * -0.9
	for i in cards.size():
		var target_pos := Vector3(left + 0.9 * i,0,0)
		tween.tween_property(cards[i],"position",target_pos,0.5)
	tween.set_parallel(false)
	tween.tween_interval(0.2)
	tween.tween_interval(0.0)
	tween.set_parallel(true)
	for i in cards.size():
		tween.tween_property(cards[i],"rotation",Vector3(0,0,0),0.5)
	await tween.finished
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(control,"modulate:a",0,0.5)
	await tween.finished
	


var _click : bool = false

func on_card_input_event(card : Card3D,_camera : Camera3D, event : InputEvent, _hit_position : Vector3):
	if _click:
		if (event is InputEventMouseButton
				and event.button_index == MOUSE_BUTTON_LEFT
				and not event.pressed):
			var i = cards.find(card)
			if i >= 0:
				exchanges[i].visible = not exchanges[i].visible
			_click = false
	else:
		if (event is InputEventMouseButton
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.pressed):
			_click = true


func _on_button_pressed():
	decided.emit()

