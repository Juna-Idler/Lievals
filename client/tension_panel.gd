@tool

extends Control

const EMPTY_COLOR = Color(0.25, 0, 0.6)
const CHARGE_COLOR = Color(0.5, 0.1, 1)


@export var opponent_layout : bool = false :
	set(v):
		opponent_layout = v
		if is_node_ready():
			set_layout()

@export var tension : int = 0 :
	set(v):
		tension = v
		if is_node_ready():
			set_tension()


@onready var leader_image : TextureRect = $LeaderImage
@onready var skill_image : TextureRect = $SkillImage

@onready var charge_1 : ColorRect = $Charge1
@onready var charge_2 : ColorRect = $Charge2
@onready var charge_3 : ColorRect = $Charge3


# Called when the node enters the scene tree for the first time.
func _ready():
	set_tension()
	set_layout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_layout():
	if opponent_layout:
		leader_image.position.x = 0
		charge_1.position.x = 64
		charge_2.position.x = 140
		charge_3.position.x = 136
		skill_image.position.x = 128
	else:
		leader_image.position.x = 32
		charge_1.position.x = 24
		charge_2.position.x = 8
		charge_3.position.x = 4
		skill_image.position.x = 4

func set_tension():
	if tension >= 1:
		charge_1.color = CHARGE_COLOR
	else:
		charge_1.color = EMPTY_COLOR
	if tension >= 2:
		charge_2.color = CHARGE_COLOR
	else:
		charge_2.color = EMPTY_COLOR
	if tension >= 3:
		charge_3.color = CHARGE_COLOR
	else:
		charge_3.color = EMPTY_COLOR	
