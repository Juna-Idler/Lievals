extends Control

class_name CardFaceUnit

@onready var card_name_label = $CardNameLabel
@onready var card_text_label = $CardTextLabel
@onready var strain_label = $TraitsLabel
@onready var cost_label = $Polygon2D/CostLabel
@onready var attack_mark = $AttackMark
@onready var hp_mark = $HpMark

@onready var texture_rect = $TextureRect


func initialize(card_name : String,card_text : String,cost : int,attack : int,hp : int,strain : CardData.UnitStrain,
		texture : Texture2D):
	card_name_label.text = card_name
	card_text_label.text = card_text
	cost_label.text = str(cost)
	attack_mark.stat = attack
	hp_mark.stat = hp
	if strain != CardData.UnitStrain.なし:
		var index := CardData.UnitStrain.values().find(strain)
		strain_label.show()
		strain_label.text = CardData.UnitStrain.keys()[index]
	else:
		strain_label.hide()
	texture_rect.texture = texture

