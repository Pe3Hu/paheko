extends MarginContainer


@onready var pillars = $Pillars

var gambler = null


func set_attributes(input_: Dictionary) -> void:
	gambler = input_.gambler
	custom_minimum_size = Vector2(Global.vec.size.altar)
	pillars.position = custom_minimum_size * 0.5
	init_pillars()




func init_pillars() -> void:
	var n = 8
	var angle = PI * 2 / n
	
	for _i in n:
		var input = {}
		input.altar = self
		input.position = Vector2.from_angle(angle * _i) * Global.num.altar.r
	
		var pillar = Global.scene.pillar.instantiate()
		pillars.add_child(pillar)
		pillar.set_attributes(input)
