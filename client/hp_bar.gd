@tool

extends Control

@export var opponent_layout : bool = false :
	set(v):
		opponent_layout = v
		if number:
			if opponent_layout:
				number.anchors_preset = PRESET_TOP_LEFT
				progress_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN
			else:
				number.anchors_preset = PRESET_TOP_RIGHT
				progress_bar.fill_mode = ProgressBar.FILL_BEGIN_TO_END
		

@export var value : int :
	set(v):
		value = v
		if digit:
			digit.text = str(value)
			progress_bar.value = value

@onready var number = $Number
@onready var digit : Label =$Number/Digit
@onready var progress_bar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	digit.text = str(value)
	progress_bar.value = value
	if opponent_layout:
		number.anchors_preset = PRESET_TOP_LEFT
	else:
		number.anchors_preset = PRESET_TOP_RIGHT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
