#HiddenPairs.gd
extends Node

# Function to solve Hidden Pairs in the candidates array
func solve(candidates: Array) -> Array:
	#print("HiddenPairs")
	#var check = candidates.duplicate(true)
	var updated = false

	# Check each row, column, and box for Hidden Pairs
	for i in range(9):
		if _check_hidden_pairs_unit(candidates, i, true) or _check_hidden_pairs_unit(candidates, i, false) or _check_hidden_pairs_box(candidates, i):
			updated = true

#	if check != candidates:
#		print("HiddenPairs used")
	return candidates

# Helper function to check and resolve Hidden Pairs in a row or column
func _check_hidden_pairs_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var number_positions = _get_number_positions_for_unit(candidates, index, is_row)

	for num1 in range(1, 10):
		if number_positions[num1 - 1].size() == 2:
			for num2 in range(num1 + 1, 10):
				if number_positions[num2 - 1] == number_positions[num1 - 1]:
					# Found a hidden pair
					for cell in number_positions[num1 - 1]:
						updated = _set_to_hidden_pair(candidates, cell.x, cell.y, [num1, num2]) or updated

	return updated

# Helper function to check and resolve Hidden Pairs in a 3x3 box
func _check_hidden_pairs_box(candidates: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	var number_positions = _get_number_positions_for_box(candidates, start_row, start_col)

	for num1 in range(1, 10):
		if number_positions[num1 - 1].size() == 2:
			for num2 in range(num1 + 1, 10):
				if number_positions[num2 - 1] == number_positions[num1 - 1]:
					# Found a hidden pair
					for cell in number_positions[num1 - 1]:
						updated = _set_to_hidden_pair(candidates, cell.x, cell.y, [num1, num2]) or updated

	return updated

# Helper function to get the positions of numbers in a row or column
func _get_number_positions_for_unit(candidates: Array, index: int, is_row: bool) -> Array:
	var number_positions = []
	for num in range(1, 10):
		number_positions.append([])
		for i in range(9):
			var cell_row = index if is_row else i
			var cell_col = i if is_row else index
			if num in candidates[cell_row][cell_col]:
				number_positions[num - 1].append(Vector2(cell_row, cell_col))
	return number_positions

# Helper function to get the positions of numbers in a 3x3 box
func _get_number_positions_for_box(candidates: Array, start_row: int, start_col: int) -> Array:
	var number_positions = []
	for num in range(1, 10):
		number_positions.append([])
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				if num in candidates[cell_row][cell_col]:
					number_positions[num - 1].append(Vector2(cell_row, cell_col))
	return number_positions

# Helper function to set a cell's candidates to only the hidden pair
func _set_to_hidden_pair(candidates: Array, row: int, col: int, pair: Array) -> bool:
	var updated = false
	if candidates[row][col] != pair:
		candidates[row][col] = pair.duplicate()
		updated = true
	return updated
