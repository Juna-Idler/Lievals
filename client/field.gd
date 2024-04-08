extends Node3D

class_name Field


@onready var own_leader_square : FieldSquare = $Own/Square0

@onready var own_unit_squares : Array[FieldSquare] = [
	$Own/Square1,
	$Own/Square2,
	$Own/Square3,
	$Own/Square4,
	$Own/Square5,
	$Own/Square6,
]
@onready var rival_leader_square : FieldSquare = $Rival/Square0

@onready var rival_unit_squares : Array[FieldSquare] = [
	$Rival/Square1,
	$Rival/Square2,
	$Rival/Square3,
	$Rival/Square4,
	$Rival/Square5,
	$Rival/Square6,
]

@onready var selected_square = $SelectedSquare

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 6:
		own_unit_squares[i].mouse_entered.connect(_on_square_mouse_entered.bind(own_unit_squares[i]))
		rival_unit_squares[i].mouse_entered.connect(_on_square_mouse_entered.bind(rival_unit_squares[i]))
		own_unit_squares[i].mouse_exited.connect(_on_square_mouse_exited.bind(own_unit_squares[i]))
		rival_unit_squares[i].mouse_exited.connect(_on_square_mouse_exited.bind(rival_unit_squares[i]))
	own_leader_square.mouse_entered.connect(_on_square_mouse_entered.bind(own_leader_square))
	rival_leader_square.mouse_entered.connect(_on_square_mouse_entered.bind(rival_leader_square))
	own_leader_square.mouse_exited.connect(_on_square_mouse_exited.bind(own_leader_square))
	rival_leader_square.mouse_exited.connect(_on_square_mouse_exited.bind(rival_leader_square))

	for i in 6:
		own_unit_squares[i].unit = bool(randi() & 1)
		rival_unit_squares[i].unit = bool(randi() & 1)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_attack():
	for i in 6:
		own_unit_squares[i].set_attack()
	own_leader_square.set_attack()

func set_choice(choice_type : Mechanics.Choice):
	match choice_type:
		Mechanics.Choice.NO_CHOICE:
			for i in 6:
				own_unit_squares[i].chooseable = false
				rival_unit_squares[i].chooseable = false
			own_leader_square.chooseable = false
			rival_leader_square.chooseable = false
		Mechanics.Choice.CARD_CHOICE:
			for i in 6:
				own_unit_squares[i].chooseable = false
				rival_unit_squares[i].chooseable = false
			own_leader_square.chooseable = false
			rival_leader_square.chooseable = false
		Mechanics.Choice.HAND_CHOICE:
			for i in 6:
				own_unit_squares[i].chooseable = false
				rival_unit_squares[i].chooseable = false
			own_leader_square.chooseable = false
			rival_leader_square.chooseable = false
			
		Mechanics.Choice.TARGET_ONE:
			pass
		Mechanics.Choice.UNIT_ONE:
			pass
		Mechanics.Choice.FRIEND_ONE:
			pass
		Mechanics.Choice.FRIEND_UNIT_ONE:
			pass
		Mechanics.Choice.ENEMY_ONE:
			pass
		Mechanics.Choice.ENEMY_UNIT_ONE:
			pass
		Mechanics.Choice.FRONT_UNIT_ONE:
			pass
		Mechanics.Choice.FRIEND_FRONT_UNIT_ONE:
			pass
		Mechanics.Choice.ENEMY_FRONT_UNIT_ONE:
			pass
		Mechanics.Choice.BACK_UNIT_ONE:
			pass
		Mechanics.Choice.FRIEND_BACK_UNIT_ONE:
			pass
		Mechanics.Choice.ENEMY_BACK_UNIT_ONE:
			pass
		Mechanics.Choice.FIELD_ONE:
			pass
		Mechanics.Choice.FRIEND_FIELD_ONE:
			pass
		Mechanics.Choice.ENEMY_FIELD_ONE:
			pass
		Mechanics.Choice.OPEN_FIELD_ONE:
			pass
		Mechanics.Choice.FRIEND_OPEN_FIELD_ONE:
			for i in 6:
				if not own_unit_squares[i].unit:
					own_unit_squares[i].chooseable = true
				else:
					own_unit_squares[i].chooseable = false
			for s in rival_unit_squares:
				s.chooseable = false
			own_leader_square.chooseable = false
			rival_leader_square.chooseable = false
		Mechanics.Choice.ENEMY_OPEN_FIELD_ONE:
			pass
		Mechanics.Choice.HORIZONTAL:
			pass
		Mechanics.Choice.FRIEND_HORIZONTAL:
			pass
		Mechanics.Choice.ENEMY_HORIZONTAL:
			pass
		Mechanics.Choice.BOTH_HORIZONTAL:
			pass
		Mechanics.Choice.VERTICAL:
			pass
		Mechanics.Choice.FRIEND_VERTICAL:
			pass
		Mechanics.Choice.ENEMY_VERTICAL:
			pass
	pass
	
	


func _on_square_mouse_entered(square : FieldSquare):
	if square.chooseable:
		selected_square.show()
		selected_square.global_position = square.global_position


func _on_square_mouse_exited(_square : FieldSquare):
	selected_square.hide()
