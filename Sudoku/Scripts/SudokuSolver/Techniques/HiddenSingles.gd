#HiddenSingles.gd
extends Node

# Function to solve Hidden Singles in a Sudoku grid
func solve(candidates: Array) -> Array:
	#print("HiddenSingles")
	#var check = candidates.duplicate(true)
	var updated = false

	# Check each row, column, and box for Hidden Singles
	for i in range(9):
		updated = _check_hidden_singles_unit(candidates, i, true) or updated  # Check rows
		updated = _check_hidden_singles_unit(candidates, i, false) or updated  # Check columns
		updated = _check_hidden_singles_box(candidates, i) or updated  # Check boxes

#	if check != candidates:
#		print("HiddenSingles used")
	return candidates

# Hidden Singles in Row or Column
func _check_hidden_singles_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	for num in range(1, 10):
		var count = 0
		var hidden_single_pos = Vector2()
		# Find potential hidden single
		for i in range(9):
			var cell_row = index if is_row else i
			var cell_col = i if is_row else index
			if num in candidates[cell_row][cell_col]:
				count += 1
				hidden_single_pos = Vector2(cell_row, cell_col)
			if count > 1:
				break
		# Clear other candidates
		if count == 1:
			var x = int(hidden_single_pos.x)
			var y = int(hidden_single_pos.y)
			candidates[x][y] = [num]  # Keep only the hidden single
			updated = true
	return updated

# Hidden Singles in Box
func _check_hidden_singles_box(candidates: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	for num in range(1, 10):
		var count = 0
		var hidden_single_pos = Vector2()
		# Find potential hidden single
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				if num in candidates[cell_row][cell_col]:
					count += 1
					hidden_single_pos = Vector2(cell_row, cell_col)
				if count > 1:
					break
			if count > 1:
				break
		# Clear other candidates
		if count == 1:
			var x = int(hidden_single_pos.x)
			var y = int(hidden_single_pos.y)
			candidates[x][y] = [num]  # Keep only the hidden single
			updated = true
	return updated
