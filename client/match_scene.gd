extends Node

const MULLIGAN = preload("res://client/mulligan.tscn")
const CARD_3D = preload("res://client/card3d.tscn")

@onready var hand : PlayerHand = %Hand
@onready var field : Field = $Node3D/Field

@onready var hud : Node3D = %HUD

@onready var camera_3d : Camera3D = %Camera3D

@onready var card_holder : Node3D = %CardHolder

var drag_plane : Plane = Plane(Vector3(0,1,0),0.5)

var server : ServerInterface


# Called when the node enters the scene tree for the first time.
func _ready():
	_drag_tween = create_tween()
	_drag_tween.kill()
	hand.hand_card_input_event.connect(on_hand_card_input_event)
	hand.hand_card_mouse_entered.connect(on_hand_card_mouse_entered)
	hand.hand_card_mouse_exited.connect(on_hand_card_mouse_exited)


	var result := ServerInterface.Result.new()
	result.board = ServerInterface.Board.new()
	result.board.player = ServerInterface.Player.new()
	result.board.rival = ServerInterface.Rival.new()
	result.board.player.hand = []
	for i in 5:
		var c := ServerInterface.Card.new()
		var data := CardData.get_card_data(randi_range(1,10))
		c.deck_card_id = i
		c.base_card_id = data.id
		c.attack = data.attack
		c.cost = data.cost
		c.hp = data.hp
		result.board.player.hand.append(c)
	
	result.board.player.field = []
	result.board.rival.field = []
	for i in 7:
		var s := ServerInterface.Square.new()
		if randi() & 1:
			s.unit = ServerInterface.Unit.new()
			var data := CardData.get_card_data(randi_range(1,10))
			s.unit.base_card_id = data.id
			s.unit.attack = data.attack
			s.unit.max_hp = data.hp
			s.unit.hp = data.hp
		result.board.player.field.append(s)
		
		s = ServerInterface.Square.new()
		if randi() & 1:
			s.unit = ServerInterface.Unit.new()
			var data := CardData.get_card_data(randi_range(1,10))
			s.unit.base_card_id = data.id
			s.unit.attack = data.attack
			s.unit.max_hp = data.hp
			s.unit.hp = data.hp
		result.board.rival.field.append(s)
	
	reset_board(result.board)
	
	#for i in range(1,4):
		#var data := CardData.get_card_data(randi_range(1,10))
		#field.set_unit(i,data.id,data.attack,data.hp,data.hp)
	field.set_attack()
	pass # Replace with function body.

func start_async(server_interface : ServerInterface):
	server = server_interface
#	var mdata := server.get_matching_data()
#	var data1 := await server.send_ready_match_async()
#	if not fdata:
#		return
	hand.hide()
	var mulligan : Mulligan = MULLIGAN.instantiate()
	hud.add_child(mulligan)
	var cards : Array[Card3D] = []
	for i in 3:
		var card : Card3D = CARD_3D.instantiate()
		card_holder.add_child(card)
		card.initialize(i,randi_range(1,10))
		cards.append(card)
	
	await mulligan.start_async(true,cards,0.5)
	
	var list := await mulligan.wait_async()
#	var data2 := await server.send_mulligan_async(list)
	for i in list:
		cards[i].initialize(i,randi_range(1,10))
	await mulligan.end_async()
	hand.show()
	hand.set_cards(cards,0.5)
	mulligan.queue_free()
#	var result := await server.send_ready_turn_async()

var _performing_logs : Array[ServerInterface.Log] = []
var _latest_board : ServerInterface.Board

func perform_result_async(result : ServerInterface.Result):
	_latest_board = result.board
	if not _performing_logs.is_empty():
		_performing_logs.append_array(result.log_list)
		return
	
	_performing_logs.append_array(result.log_list)
	while not _performing_logs.is_empty():
		var log : ServerInterface.Log = _performing_logs.pop_front()
#		await perform_log(log)
		pass
	
	reset_board(_latest_board)
	


func reset_board(board : ServerInterface.Board):
	
	if hand.hands.size() == board.player.hand.size():
		return
	
	while card_holder.get_child_count() > 0:
		card_holder.remove_child(card_holder.get_child(0))

	var cards : Array[Card3D] = []
	for h in board.player.hand:
		var card : Card3D = CARD_3D.instantiate()
		card_holder.add_child(card)
		card.initialize_card(h)
		cards.append(card)

	hand.reset_cards(cards)
	
	for i in range(1,7):
		field.delete_own_unit(i)
		if board.player.field[i].unit:
			var u := board.player.field[i].unit
			field.set_own_unit(i,u.base_card_id,u.attack,u.max_hp,u.hp)
		field.delete_rival_unit(i)
		if board.rival.field[i].unit:
			var u := board.rival.field[i].unit
			field.set_rival_unit(i,u.base_card_id,u.attack,u.max_hp,u.hp)
		


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


