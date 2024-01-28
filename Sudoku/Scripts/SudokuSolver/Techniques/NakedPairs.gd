#NakedPairs.gd
extends Node

# Function to find and eliminate Naked Pairs in a Sudoku grid
func solve(candidates: Array) -> Array:
	#print("NakedPairs")
	#var check = candidates.duplicate(true)
	var updated = false

	# Check each row, column, and box for Naked Pairs
	for i in range(9):
		if _check_naked_pairs_unit(candidates, i, true) or _check_naked_pairs_unit(candidates, i, false) or _check_naked_pairs_box(candidates, i):
			updated = true

#	if check != candidates:
#		print("NakedPairs used")
	return candidates

# Helper function to check and eliminate Naked Pairs in a row or column
func _check_naked_pairs_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var possibilities = _get_possibilities_for_unit(candidates, index, is_row)

	# Check for naked pairs in the possibilities
	for i in range(possibilities.size()):
		for j in range(i + 1, possibilities.size()):
			if possibilities[i].size() == 2 and possibilities[i] == possibilities[j]:
				# Found a naked pair, eliminate these numbers from other cells in the unit
				for k in range(9):
					if k != i and k != j:
						var cell_row = index if is_row else k
						var cell_col = k if is_row else index
						updated = _eliminate_possibilities(candidates, cell_row, cell_col, possibilities[i]) or updated
	return updated

# Helper function to check and eliminate Naked Pairs in a 3x3 box
func _check_naked_pairs_box(candidates: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	var possibilities = _get_possibilities_for_box(candidates, start_row, start_col)

	# Check for naked pairs in the possibilities
	for i in range(possibilities.size()):
		for j in range(i + 1, possibilities.size()):
			if possibilities[i].size() == 2 and possibilities[i] == possibilities[j]:
				# Found a naked pair, eliminate these numbers from other cells in the box
				for k in range(9):
					if k != i and k != j:
						var cell_row = start_row + (k / 3)
						var cell_col = start_col + (k % 3)
						updated = _eliminate_possibilities(candidates, cell_row, cell_col, possibilities[i]) or updated
	return updated

# Helper function to get possibilities for each cell in a unit (row, column, or box)
func _get_possibilities_for_unit(candidates: Array, index: int, is_row: bool) -> Array:
	var possibilities = Array()
	for i in range(9):
		var cell_candidates = candidates[index][i] if is_row else candidates[i][index]
		possibilities.append(cell_candidates)
	return possibilities

func _get_possibilities_for_box(candidates: Array, start_row: int, start_col: int) -> Array:
	var possibilities = Array()
	for i in range(3):
		for j in range(3):
			var cell_candidates = candidates[start_row + i][start_col + j]
			possibilities.append(cell_candidates)
	return possibilities

# Helper function to eliminate possibilities from a cell
func _eliminate_possibilities(candidates: Array, row: int, col: int, numbers_to_eliminate: Array) -> bool:
	var updated = false
	var cell_candidates = candidates[row][col]
	if typeof(cell_candidates) == TYPE_ARRAY:
		for number in numbers_to_eliminate:
			if number in cell_candidates:
				cell_candidates.erase(number)
				updated = true
	return updated
