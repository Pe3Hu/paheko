extends MarginContainer


@onready var gameboard = $VBox/Gameboard

var casino = null
var combinations = {}


func set_attributes(input_: Dictionary) -> void:
	casino = input_.casino
	
	var input = {}
	input.gambler = self
	gameboard.set_attributes(input)
	
	find_all_combinations()


func find_all_combinations() -> void:
	var n = gameboard.hand.capacity.current
	var m = gameboard.available.cards.get_child_count()
	var k = 0
	
	for _i in pow(m, 5):
		var indexs = get_indexs(_i)
		
		if indexs.size() == n:
			combinations[k] = {}
			combinations[k].indexs = indexs
			#print([_i, combination[k]])
			
			gameboard.hand.refill_based_on_card_indexs(indexs)
			combinations[k].combinations = gameboard.hand.check_all_combinations()
			gameboard.hand.discard()
	
			print(combinations[k])
			k += 1


func get_indexs(index_: int) -> Array:
	var n = gameboard.hand.capacity.current
	var m = gameboard.available.cards.get_child_count()
	var indexs = []
	
	var _i = 0
	
	while index_ >= m:
		var index = index_ % m
		
		if !indexs.has(index):
			indexs.append(index)
		else:
			return []
		
		index_ /= m
		_i += 1
	
	if !indexs.has(index_):
		indexs.append(index_)
	else:
		return []
	
	return indexs


func get_indexs_old(index_: int) -> Array:
	var n = gameboard.hand.capacity.current
	var m = gameboard.available.cards.get_child_count()
	var indexs = []
	
	for _i in n:
		indexs.append(0)
	
	var _i = 0
	
	while index_ >= m:
		indexs[_i] = index_ % m
		index_ /= m
		_i += 1
	
	indexs[_i] = index_ % m
	
	return indexs
