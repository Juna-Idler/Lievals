extends Node

@onready var match_scene = $MatchScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	match_scene.start_async(null)
	pass # Replace with function body.
