@tool

extends Control

@onready var polygon_2d = $Polygon2D
@onready var label = $Label


@export var color : Color = Color.RED :
	set(v):
		color = v
		if polygon_2d:
			polygon_2d.color = color
		
@export var stat : int = 0 :
	set(v):
		assert(v >= 0)
		stat = v
		if label:
			label.text = str(stat)

func _ready():
	polygon_2d.color = color
	label.text = str(stat)
	

