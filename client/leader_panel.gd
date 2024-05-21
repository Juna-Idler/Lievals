@tool

extends Node3D

const TENSION_POS = Vector3(-0.8,0.125,-0.01)
const OPPONENT_TENSION_POS = Vector3(0.8,0.125,-0.01)



@export var opponent_layout : bool = false :
	set(v):
		opponent_layout = v
		if count_panel:
			count_panel.opponent_layout = opponent_layout
			tension_panel.opponent_layout = opponent_layout
			$TensionPanel.position = OPPONENT_TENSION_POS if opponent_layout else TENSION_POS 
		

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

@export var tension_value : int :
	set(v):
		tension_value = v
		if tension_panel:
			tension_panel.tension = tension_value

@onready var count_panel = $SubViewport/CountPanel
@onready var tension_panel = $SubViewport2/TensionPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	count_panel.opponent_layout = opponent_layout
	count_panel.hp_value = hp_value
	count_panel.mp_value = mp_value
	count_panel.max_mp_value = max_mp_value
	count_panel.deck_value = deck_value
	
	tension_panel.opponent_layout = opponent_layout
	tension_panel.tension = tension_value
	$TensionPanel.position = OPPONENT_TENSION_POS if opponent_layout else TENSION_POS 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
