extends MarginContainer


@onready var cards = $Cards

var capacity = {}
var gameboard = null
var ranks = {}
var suits = {}


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	capacity.current = 6
	capacity.limit = 10


func refill() -> void:
	gameboard.reshuffle_available()
	
	while cards.get_child_count() < capacity.current and gameboard.available.cards.get_child_count() > 0:
		var card = gameboard.pull_random_card()
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


func get_all_kits() -> Dictionary:
	var kits = {}
	
	for kit in Global.arr.kit:
		var name_ = "get_" + kit + "_kits"
		
		#for count in Global.arr.count:
		var count = capacity.current
		kits[kit] = call("get_kits_based_on_type_and_count", kit, count)
	
	return kits


func get_kits_based_on_type_and_count(type_: String, count_: int) -> Array:#args_: Array) -> Array:
	var kits = []
	var datas = {}
	datas[0] = {}
	datas[0] = []
	var options = cards.get_children()
	
	for option in options:
		datas[0].append([option])
	
	#var type = args_[0]
	#var count = args_[1]
	
	for _i in count_:
		datas[_i+1] = []
		
		for parents in datas[_i]:
			var childs = []
			
			for option in options:
				if !parents.has(option):
					var flag = call("validate_"+type_, parents, option)
					
					if flag:
						childs.append(option)
			
			for child in childs:
				var parents_ = [child]
				parents_.append_array(parents)
				parents_.sort_custom(func(a, b): return a.get_index_number() < b.get_index_number())
				
				if !datas[_i+1].has(parents_):
					datas[_i+1].append(parents_)
	
	for _i in datas:
		if _i > 0:
			kits.append_array(datas[_i])
#			for cards_ in datas[_i]:
#				print("___",_i+1)
#				for card in cards_:
#					print([card.get_suit(), card.get_rank()])
	
	return kits



func validate_unity(parents_: Array, child_: MarginContainer) -> bool:
	return parents_.front().get_suit() == child_.get_suit()


func validate_harmony(parents_: Array, child_: MarginContainer) -> bool:
	return parents_.front().get_rank() == child_.get_rank()


func validate_order(parents_: Array, child_: MarginContainer) -> bool:
	var first = parents_.front().get_rank() == child_.get_rank() + 1
	var last = parents_.back().get_rank() + 1 == child_.get_rank()
	
	if !first:
		first = child_.get_rank() == Global.arr.rank.back() and parents_.front().get_rank() == Global.arr.rank.front()
	
	if !last:
		last = child_.get_rank() == Global.arr.rank.front() and parents_.front().get_rank() == Global.arr.rank.back()
	
	return first or last
