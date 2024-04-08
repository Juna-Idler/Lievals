extends Control

var board : Mechanics.Board

# Called when the node enters the scene tree for the first time.
func _ready():
	board = Mechanics.Board.new()
	var deck : Array[int] = [1,1,1,1,1,1,1,1,1,1]
	board.initialize(deck,deck)
	board.mulligan(1,[])
	board.mulligan(2,[])
	board.start_turn()
	while not board.turn_start_friend_effect():
		board.resume_condition
		board.resume([])
	while not board.turn_start_enemy_effect():
		board.resume_condition
		board.resume([])
	
	board.play_unit(0,1,[])
	
	board.end_turn()
	while not board.turn_end_friend_effect():
		board.resume_condition
		board.resume([])
	while not board.turn_end_enemy_effect():
		board.resume_condition
		board.resume([])
	
	board.turn_end()
	board.start_turn()
	
	print("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
