@tool

extends Control

const GREEN = Color(0, 1, 0)
const ORANGE = Color(0.8, 0.4, 0)

@export var opponent_layout : bool = false :
	set(v):
		opponent_layout = v
		if is_node_ready():
			set_layout()
		

@export var hp_value : int = 25 :
	set(v):
		hp_value = v
		if hp:
			hp.text = str(hp_value)
			progress_bar.value = hp_value

@export var mp_value : int :
	set(v):
		mp_value = v
		if mp:
			mp.text = str(mp_value)

@export var max_mp_value : int :
	set(v):
		max_mp_value = v
		if max_mp:
			max_mp.text = str(max_mp_value)

@export var deck_value : int = 27 :
	set(v):
		deck_value = v
		if deck:
			deck.text = str(deck_value)



@onready var hp_count = $HpBar/HpCount
@onready var hp : Label = $HpBar/HpCount/Hp
@onready var progress_bar = $HpBar/ProgressBar

@onready var mp_count = $HBoxContainer/MpCount
@onready var mp : Label = $HBoxContainer/MpCount/Mp
@onready var max_mp : Label = $HBoxContainer/MpCount/MaxMp

@onready var deck_count = $HBoxContainer/DeckCount
@onready var deck : Label = $HBoxContainer/DeckCount/Deck

@onready var h_box_container = $HBoxContainer
@onready var texture_rect : TextureRect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	hp.text = str(hp_value)
	progress_bar.value = hp_value
	mp.text = str(mp_value)
	max_mp.text = str(max_mp_value)
	deck.text = str(deck_value)
	
	set_layout()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_layout():
	if opponent_layout:
		hp_count.anchors_preset = PRESET_TOP_LEFT
		progress_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN
		h_box_container.move_child(deck_count,0)
		texture_rect.flip_h = true
	else:
		hp_count.anchors_preset = PRESET_TOP_RIGHT
		progress_bar.fill_mode = ProgressBar.FILL_BEGIN_TO_END
		h_box_container.move_child(mp_count,0)
		texture_rect.flip_h = false
