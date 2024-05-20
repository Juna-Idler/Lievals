@tool

extends Node3D

@export var opponent_layout : bool = false :
	set(v):
		opponent_layout = v
		if count_panel:
			count_panel.opponent_layout = opponent_layout
		

@export var hp_value : int = 25 :
	set(v):
		hp_value = v
		if count_panel:
			count_panel.hp_value = hp_value

@export var mp_value : int :
	set(v):
		mp_value = v
		if count_panel:
			count_panel.mp_value = mp_value

@export var max_mp_value : int :
	set(v):
		max_mp_value = v
		if count_panel:
			count_panel.max_mp_value = max_mp_value

@export var deck_value : int = 27 :
	set(v):
		deck_value = v
		if count_panel:
			count_panel.deck_value = deck_value


@onready var count_panel = $SubViewport/CountPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	count_panel.opponent_layout = opponent_layout
	count_panel.hp_value = hp_value
	count_panel.mp_value = mp_value
	count_panel.max_mp_value = max_mp_value
	count_panel.deck_value = deck_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
