extends MarginContainer


@onready var cards = $Cards

var capacity = {}
var gameboard = null
var ranks = {}
var suits = {}


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	capacity.current = 4
	capacity.limit = 10


func refill() -> void:
	gameboard.reshuffle_available()
	
	while cards.get_child_count() < capacity.current and gameboard.available.cards.get_child_count() > 0:
		var card = gameboard.pull_card()
		add_card(card)


func add_card(card_: MarginContainer) -> void:
	cards.add_child(card_)
	var suit = card_.get_suit()
	var rank = card_.get_rank()
	#print([suit, rank])
	
	if !suits.has(suit):
		suits[suit] = 0
	
	if !ranks.has(rank):
		ranks[rank] = 0
	
	suits[suit] += 1
	ranks[rank] += 1


func refill_based_on_card_indexs(indexs_: Array) -> void:
	var a = gameboard.available.cards.get_child_count()
	var b = gameboard.available.cards.get_children()
	for index in indexs_:
		draw_indexed_card(index)


func draw_indexed_card(index_: int) -> void:
	var card = gameboard.pull_indexed_card(index_)
	add_card(card)


func apply() -> void:
	for card in cards.get_children():
		apply_card(card)


func apply_card(card_: MarginContainer) -> void:
	#for token in card_.tokens.get_children():
	#	var value = token.stack.get_number()
	#	gameboard.change_token_value(token.title.subtype, value)
	pass


func discard() -> void:
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		discard_card(card)
	
	#print(gameboard.available.cards.get_child_count())


func discard_card(card_: MarginContainer) -> void:
	cards.remove_child(card_)
	#card_.charge.current -= 1
	var suit = card_.get_suit()
	var rank = card_.get_rank()
	suits[suit] -= 1
	ranks[rank] -= 1
	
	if suits[suit] == 0:
		suits.erase(suit)
	
	if ranks[rank] == 0:
		ranks.erase(rank)
	
	if card_.charge.current > 0:
		gameboard.available.cards.add_child(card_)
	else:
		gameboard.discharged.cards.add_child(card_)
		card_.area = gameboard.discharged


func check_all_combinations() -> String:
	var combinations = []
	
	for combination in Global.arr.combination:
		var flag = call(combination+"_check")
		
		if flag:
			combinations.append(combination)
	
	if combinations.has("straight_on_flush"):
		combinations.erase("straight")
		combinations.erase("flush")
	
	if combinations.has("roayl_flush"):
		combinations.erase("straight_on_flush")
	
	if combinations.is_empty():
		combinations.append("high card")
	
	return combinations.front()


func duplet_check() -> bool:
	var counts = []
	
	for rank in ranks:
		counts.append(ranks[rank])
	
	counts.sort_custom(func(a, b): return a > b)
	return counts[0] == 2 and counts[1] == 1


func duplet_on_duplet_check() -> bool:
	var counts = []
	
	for rank in ranks:
		counts.append(ranks[rank])
	
	counts.sort_custom(func(a, b): return a > b)
	return counts[0] == 2 and counts[1] == 2


func triplet_check() -> bool:
	var counts = []
	
	for rank in ranks:
		counts.append(ranks[rank])
	
	counts.sort_custom(func(a, b): return a > b)
	return counts[0] == 3# and counts[1] == 1


func triplet_on_duplet_check() -> bool:
	var counts = []
	
	for rank in ranks:
		counts.append(ranks[rank])
	
	counts.sort_custom(func(a, b): return a > b)
	
	if counts.size() > 1:
		return counts[0] == 3 and counts[1] == 2
	else:
		return false


func quartet_check() -> bool:
	var counts = []
	
	for rank in ranks:
		counts.append(ranks[rank])
	
	counts.sort_custom(func(a, b): return a > b)
	#if counts.size() > 1:
	return counts[0] == 4
	#else:
	#	return counts[0] == 4 and counts[1] == 1


func quintet_check() -> bool:
	return ranks.keys().size() == 1


func flush_check() -> bool:
	return suits.keys().size() == 1


func straight_check() -> bool:
	for rank in ranks:
		if ranks[rank] != 1:
			return false
	
	var keys = []
	keys.append_array(ranks.keys())
	keys.sort()
	
	var flag = true
	
	for _i in keys.size()-1:
		flag = flag and keys[_i] + 1 == keys[_i + 1]
		
		if !flag and _i == keys.size()-2:
			if keys[_i + 1] == Global.arr.rank.back() and keys[0] == Global.arr.rank.front():
				flag = true
		
		if !flag:
			return flag
	
	return flag


func straight_on_flush_check() -> bool:
	return flush_check() and straight_check()


func roayl_flush_check() -> bool:
	return straight_on_flush_check() and ranks.has(Global.arr.rank.back()) and !ranks.has(Global.arr.rank.front())
