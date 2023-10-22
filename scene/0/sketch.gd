extends MarginContainer


@onready var casino = $HBox/Casino


func _ready() -> void:
	var input = {}
	input.sketch = self
	casino.set_attributes(input)
	
