
class_name Mechanics


enum Phase {
	GAME_END,
	MULLIGAN,
	MULLIGAN_P1FINISHED,
	MULLIGAN_P2FINISHED,
	MULLIGAN_FINISHED,
	TURN_START_FRIEND,
	TURN_START_ENEMY,
	MAIN,
	CHOICE,
	TURN_END_FRIEND,
	TURN_END_ENEMY,
	TURN_END_EFFECT,
}

enum Choice {
	NO_CHOICE,
	CARD_CHOICE,
	HAND_CHOICE,
	TARGET_ONE,
	UNIT_ONE,
	FRIEND_ONE,
	FRIEND_UNIT_ONE,
	ENEMY_ONE,
	ENEMY_UNIT_ONE,
	FRONT_UNIT_ONE,
	FRIEND_FRONT_UNIT_ONE,
	ENEMY_FRONT_UNIT_ONE,
	BACK_UNIT_ONE,
	FRIEND_BACK_UNIT_ONE,
	ENEMY_BACK_UNIT_ONE,
	FIELD_ONE,
	FRIEND_FIELD_ONE,
	ENEMY_FIELD_ONE,
	OPEN_FIELD_ONE,
	FRIEND_OPEN_FIELD_ONE,
	ENEMY_OPEN_FIELD_ONE,
	HORIZONTAL,
	FRIEND_HORIZONTAL,
	ENEMY_HORIZONTAL,
	BOTH_HORIZONTAL,
	VERTICAL,
	FRIEND_VERTICAL,
	ENEMY_VERTICAL,
}


class Board:
	var turn_count : int
	var turn_player : Player
	var phase : Phase
	var player1 : Player = Player.new()
	var player2 : Player = Player.new()

	var suspended : ChooseableEffect
	var resume_condition : Choice
	var suspend_point : int
	var suspend_point2 : int

	func initialize(p1deck : Array[int],p2deck : Array[int]):
		turn_count = 0
		turn_player = null
		phase = Phase.MULLIGAN
		player1.initialize(p1deck,true)
		player2.initialize(p2deck,false)
		player1.rival = player2
		player2.rival = player1

	func mulligan(player_number : int,hand_index : Array[int]):
		if player_number == 1:
			if phase == Phase.MULLIGAN or phase == Phase.MULLIGAN_P2FINISHED:
				player1.mulligan(hand_index)
				if phase == Phase.MULLIGAN:
					phase = Phase.MULLIGAN_P1FINISHED
				else:
					phase = Phase.MULLIGAN_FINISHED
			else:
				return
		elif player_number == 2:
			if phase == Phase.MULLIGAN or phase == Phase.MULLIGAN_P1FINISHED:
				player2.mulligan(hand_index)
				if phase == Phase.MULLIGAN:
					phase = Phase.MULLIGAN_P2FINISHED
				else:
					phase = Phase.MULLIGAN_FINISHED
			else:
				return
		if phase == Phase.MULLIGAN_FINISHED:
			turn_player = player1
			phase = Phase.TURN_START_FRIEND

	func start_turn():
		assert(phase == Phase.TURN_START_FRIEND)
		turn_count += 1
		turn_player.start_turn()
		suspended = null
		resume_condition = Choice.NO_CHOICE
		suspend_point = 0
		suspend_point2 = 0

					
	
	func _turn_effect(player : Player,type : GDScript) -> bool:
		while suspend_point < player.units.size():
			var unit := player.units[suspend_point]
			suspend_point += 1
			if unit == null or unit.hp <= 0:
				continue
			while suspend_point2 < unit.permanent_effect.size():
				var effect := unit.permanent_effect[suspend_point2]
				suspend_point2 += 1
				if is_instance_of(effect,type):
					var choice := effect.activate(player,phase,[])
					if choice != Choice.NO_CHOICE:
						resume_condition = choice
						suspended = effect
						return false
			suspend_point2 = 0
		return true

	func turn_start_friend_effect() -> bool:
		assert(phase == Phase.TURN_START_FRIEND)
		if not _turn_effect(turn_player,TurnStartEffect):
			return false
		phase = Phase.TURN_START_ENEMY
		suspend_point = 0
		suspend_point2 = 0
		return true

	func turn_start_enemy_effect() -> bool:
		assert(phase == Phase.TURN_START_ENEMY)
		if not _turn_effect(turn_player.rival,TurnStartEffect):
			return false
		phase = Phase.MAIN
		suspend_point = 0
		suspend_point2 = 0
		return true
	
	
	func end_turn():
		assert(phase == Phase.MAIN)
		phase = Phase.TURN_END_FRIEND

	func turn_end_friend_effect() -> bool:
		assert(phase == Phase.TURN_END_FRIEND)
		if not _turn_effect(turn_player,TurnEndEffect):
			return false
		phase = Phase.TURN_END_ENEMY
		suspend_point = 0
		suspend_point2 = 0
		return true

	func turn_end_enemy_effect() -> bool:
		assert(phase == Phase.TURN_END_ENEMY)
		if not _turn_effect(turn_player.rival,TurnEndEffect):
			return false
		phase = Phase.TURN_END_EFFECT
		suspend_point = 0
		suspend_point2 = 0
		return true
		
	func turn_end():
		assert(phase == Phase.TURN_END_EFFECT)
		for u in turn_player.units:
			if u:
				if u.keyword.has(CardData.Keyword.毒):
					u.hp -= 1
		for u in turn_player.rival.units:
			if u:
				if u.keyword.has(CardData.Keyword.毒):
					u.hp -= 1
		
		phase = Phase.TURN_START_FRIEND
		if turn_player == player1:
			turn_player = player2
		elif turn_player == player2:
			turn_player = player1
		


	func play_unit(hand_index : int,position : int,param : Array) -> bool:
		assert(turn_player.units[position] == null)
		var card := turn_player.hand[hand_index]
		if card.cost > turn_player.mp:
			return true
		turn_player.mp -= card.cost
		var unit := Unit.create_from_card(card)
		turn_player.units[position] = unit
		if card.play_effect and card.play_effect is SummonsEffect:
			var choice := (card.play_effect as SummonsEffect).activate_summons(turn_player,position,param)
			if choice != Choice.NO_CHOICE:
				suspended = card.play_effect
				return false
		return true

	func play_skill(hand_index : int,param : Array):
		var card := turn_player.hand[hand_index]
		if card.cost > turn_player.mp:
			return true
		turn_player.mp -= card.cost
		if card.play_effect:
			var choice := card.play_effect.activate(turn_player,phase,param)
			if choice != Choice.NO_CHOICE:
				suspended = card.play_effect
				return false
		return true


	func attack(attacker_position : int,target_position : int):
		assert(turn_player.units[attacker_position] != null and turn_player.rival.units[target_position] != null)
		
		var attacker := turn_player.units[attacker_position]
		var target := turn_player.rival.units[target_position]
		
		if not turn_player.units[attacker_position].attackable.has(target_position):
			return
		
		if not attacker.attack_effect.is_empty():
			pass
		
		target.hp -= attacker.attack
		attacker.hp -= target.attack
		
		attacker.attack_count += 1
		

	func play_tension_skill(param : Array) -> bool:
		assert(turn_player.tension == 3)
		var choice := turn_player.tension_skill.play_effect.activate(turn_player,phase,param)
		if choice != Choice.NO_CHOICE:
			suspended = turn_player.tension_skill.play_effect
			return false
		return true
	
	func play_tension_card():
		assert(turn_player.tension < 3)
		if turn_player.tension_count < turn_player.tension_limit and turn_player.mp > 0:
			turn_player.tension += 1
			turn_player.tension_count += 1
			turn_player.mp -= 1
		


	func resume(param : Array) -> bool:
		var choice := suspended.activate(turn_player,phase,param)
		if choice != Choice.NO_CHOICE:
			resume_condition = choice
			return false
		suspended = null
		return true


class Player:
	var max_mp : int
	var mp : int
	var tension : int
	var stock : Array[Card]
	var hand : Array[Card]
	var units : Array[Unit]
	var weapon
	var used : Array[CardData]
	var grave : Array[CardData]
	var tension_skill : Card
	
	var tension_count : int
	var tension_limit : int
	var draw_damage : int
	
	var counter : Dictionary
	
	var rival : Player
	
	
	func initialize(deck : Array[int],first : bool):
		max_mp = 0
		mp = 0
		tension = 0
		stock = []
		hand = []
		used = []
		units = [Unit.create_leader(),null,null,null,null,null,null]
		for id in deck:
			stock.append(Card.new(id))
		stock.shuffle()
		for i in range(3 if first else 4):
			hand.append(stock.pop_back())
		

		tension_limit = 1
		draw_damage = 1

	
	func mulligan(hand_index : Array[int]):
		var remove : Array[Card] = []
		for i in hand_index:
			remove.append(hand[i])
			hand[i] = stock.pop_back()
		stock.append_array(remove)
		stock.shuffle()

	func start_turn():
		for u in units:
			if u:
				u.fresh = false
				u.attack_count = 0
		tension_count = 0
		if max_mp < 10:
			max_mp += 1
		mp = max_mp
		draw()

	func check_hand():
		var field_space := units.has(null)
		
		for h in hand:
			if mp < h.cost:
				h.playable = false
				continue
			if h.base_card.type == CardData.CardType.ユニット:
				h.playable = field_space
				continue
			if h.base_card.type == CardData.CardType.特技:
				pass
			h.playable = true
	
	func check_unit():
		var all_targets := rival.get_all_attack_target()
		var targets := rival.get_attack_target()
		for i in 6:
			var u := units[i + 1]
			if u == null:
				continue
			if not u.is_attackable():
				u.attackable.clear()
				continue
			if u.keyword.has(CardData.Keyword.ねらい撃ち):
				u.attackable = all_targets
			else:
				u.attackable = targets
			
	func get_attack_target() -> Array[int]:
		var targets : Array[int] = []
		for i in range(1,4):
			if units[i] != null and units[i].is_におうだち():
				targets.append(i)
		if not targets.is_empty():
			return targets
		var wall : int = 0
		for i in range(1,4):
			if units[i] != null and not units[i].keyword.has(CardData.Keyword.ステルス):
				targets.append(i)
				wall += 1
			elif units[i + 3] != null and not units[i + 3].keyword.has(CardData.Keyword.ステルス):
				targets.append(i + 3)
				wall += 1
		if wall < 3:
			targets.append(0)
		return targets
	
	func get_all_attack_target() -> Array[int]:
		var targets : Array[int] = []
		for i in range(1,7):
			if units[i] != null and not units[i].keyword.has(CardData.Keyword.ステルス):
				targets.append(i)
		targets.append(0)
		return targets
			

	func draw():
		if stock.is_empty():
			units[0].hp -= draw_damage
			draw_damage += 1
			return
		var card = stock.pop_back()
		if hand.size() < 10:
			hand.append(card)
		else:
			#燃える
			pass


class Card:
	var base_card : CardData
	var cost : int
	var attack : int
	var hp : int
	
	var playable : bool
	var play_effect : ChooseableEffect
	
	var enchant_stack : Array
	
	func _init(id : int):
		base_card = CardData.get_card_data(id)
		cost = base_card.cost
		attack = base_card.attack
		hp = base_card.hp
		playable = false
		enchant_stack = []
	


class Unit:
	var base_card : CardData
	var attack : int
	var max_hp : int
	var hp : int
	var strain : CardData.UnitStrain
	
	var keyword : Array[CardData.Keyword]
	var attack_effect : Array
	var death_effect : Array
	var permanent_effect : Array[ChooseableEffect]
	
	var fresh : bool = true
	var attack_count : int = 0
#
	#var enchant_stack : Array
	var attackable : Array[int]
	
	func is_attackable() -> bool:
		if keyword.has(CardData.Keyword.攻撃不能):
			return false
		if fresh:
			if not keyword.has(CardData.Keyword.速攻):
				return false
		if attack_count > 1:
			return false
		if attack_count == 1:
			if not keyword.has(CardData.Keyword.二回攻撃):
				return false
		return true
	
	func is_におうだち() -> bool:
		return keyword.has(CardData.Keyword.におうだち) and not keyword.has(CardData.Keyword.ステルス)



	static func create_from_card(card : Card) -> Unit:
		var unit := Unit.new()
		assert(card.base_card.type == CardData.CardType.ユニット)
		unit.base_card = card.base_card
		unit.attack = card.attack
		unit.max_hp = card.hp
		unit.hp = unit.max_hp
		unit.strain = card.base_card.strain
		unit.keyword = card.base_card.keyword.duplicate()
		
		return unit
	
	static func create_leader() -> Unit:
		var leader := Unit.new()
		leader.base_card = null
		leader.attack = 0
		leader.max_hp = 25
		leader.hp = leader.max_hp
		leader.strain = CardData.UnitStrain.なし
		leader.keyword = []
		leader.fresh = false
		return leader


class ChooseableEffect:
	func activate(_player : Player,_phase : Phase,_param : Array) -> Choice:
		return Choice.NO_CHOICE
	var card_choices : Array[Card]

class SummonsEffect extends ChooseableEffect:
	var first_choice : Choice
	func activate_summons(_player : Player,_position : int,_param : Array) -> Choice:
		return Choice.NO_CHOICE

class TurnStartEffect extends ChooseableEffect:
	pass

class TurnEndEffect extends ChooseableEffect:
	pass


class Weapon:
	var base_card : CardData
	var attack : int
	var hp : int

	var keyword : Array[CardData.Keyword]
	var attack_effect : Array
	var death_effect : Array
	var permanet_effect : Array

	var enchant_stack : Array





