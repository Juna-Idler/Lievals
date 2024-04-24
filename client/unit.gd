extends Node3D

class_name Unit3D

@onready var attack_mark : StatMark = $SubViewport/Attack
@onready var hp_mark : StatMark = $SubViewport2/Hp

@onready var label_3d : Label3D = $Label3D

@onready var image = $Image

func initialize(base_card_id : int,attack : int,max_hp : int,hp : int):
	attack_mark.stat = attack
	hp_mark.stat = hp
	label_3d.text = CardData.get_card_data(base_card_id).name
	var texture_path := "res://card_image/%03d.png" % base_card_id
	var texture = load(texture_path) if FileAccess.file_exists(texture_path) else preload("res://icon.svg")
	(image.material_override as StandardMaterial3D).albedo_texture = texture


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
