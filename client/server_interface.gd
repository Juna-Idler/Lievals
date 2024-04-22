
class_name ServerInterface


class MatichingData:
	var player_name : String
	var rival_name : String


class FirstData:
	var cards : Array[int]


class SecondData:
	var cards : Array[int]
	var wait : bool
	


func get_matching_data() -> MatichingData:
	return null

func send_ready_match_async() -> FirstData:
	@warning_ignore("redundant_await")
	return await null

func send_mulligan_async(_index_list : Array[int]) -> SecondData:
	@warning_ignore("redundant_await")
	return await null

func send_ready_turn_async() -> Result:
	@warning_ignore("redundant_await")
	return await null


func send_play_unit_card_async(_card_id : int,_location : int,_param : Variant) -> Result:
	@warning_ignore("redundant_await")
	return await null

func send_play_skill_card_async(_card_id : int,_param : Variant) -> Result:
	@warning_ignore("redundant_await")
	return await null

func send_unit_attack_async(_attacker : int,_target : int) -> Result:
	@warning_ignore("redundant_await")
	return await null

func send_tension_async(_param : Variant) -> Result:
	@warning_ignore("redundant_await")
	return await null

func send_turn_end_async() -> Result:
	@warning_ignore("redundant_await")
	return await null

func send_retire_async() -> Result:
	@warning_ignore("redundant_await")
	return await null



enum ResultType{
	Playable,
	NonPlayable,
	Choose,
	ChangeTurn,
	GameEnd,
}

class Result:
	var result_type : ResultType
	var log_list : Array[Log]
	var board
	var turn_count : int

class Log:
	pass

class NonPlayableBoard:
	var rival : RivalPlayer
	var player : NonplayablePlayer

class PlayableBoard:
	var rival : RivalPlayer
	var player : PlayablePlayer



class RivalPlayer:
	var max_mp : int
	var mp : int
	var tension : int
	var hand_count : int
	var field : Array[Square]
	var weapon
	var tension_skill : int

class NonplayablePlayer:
	var max_mp : int
	var mp : int
	var tension : int
	var hand : Array[Card]
	var field : Array[Square]
	var weapon
	var tension_skill : int

class PlayablePlayer:
	var max_mp : int
	var mp : int
	var tension : int
	var hand : Array[PlayableCard]
	var field : Array[PlayableSquare]
	var weapon
	var tension_skill : int
	
	var normal_attack_target : Array
	var all_attack_target : Array

class Card:
	var deck_card_id : int
	var base_card_id : int
	var cost : int
	var attack : int
	var hp : int
	var extra : Dictionary

class Unit:
	var base_card_id : int
	var attack : int
	var max_hp : int
	var hp : int
	var flag : int
	var effect : Array
	var extra : Dictionary

class Square:
	var unit : Unit
	

enum Choice {
	NO_CHOICE,
	CARD_CHOICE,
	HAND_CHOICE,
	UNIT_ONE,
	SQUARE_ONE,
	
	HORIZONTAL,
	FRIEND_HORIZONTAL,
	ENEMY_HORIZONTAL,
	BOTH_HORIZONTAL,
	VERTICAL,
	FRIEND_VERTICAL,
	ENEMY_VERTICAL,
}

class PlayableCard extends Card:
	var playable : bool
	var choice_type : Choice
	var target : Array


class PlayableSquare extends Square:
	var attackable : bool
	var sniping : bool
	var summonable : bool

