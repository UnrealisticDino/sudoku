#FullHouse.gd
extends Node

# Function to solve Full House in a Sudoku grid
func solve(candidates: Array) -> Array:
	#print("FullHouse")
	#var check = candidates.duplicate(true)
	var updated = false

	# Check each row, column, and box for Full House
	for i in range(9):
		updated = _check_full_house_unit(candidates, i, true) or updated  # Check rows
		updated = _check_full_house_unit(candidates, i, false) or updated  # Check columns
		updated = _check_full_house_box(candidates, i) or updated  # Check boxes

#	if check != candidates:
#		print("FullHouse used")
	return candidates

# General helper function to check and fill Full House in a row or column
func _check_full_house_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	for num in range(1, 10):
		var count = 0
		var last_empty_cell = Vector2()
		for i in range(9):
			var cell_candidates = candidates[index][i] if is_row else candidates[i][index]
			if typeof(cell_candidates) == TYPE_ARRAY and num in cell_candidates:
				last_empty_cell = Vector2(index, i) if is_row else Vector2(i, index)
				count += 1
			if count > 1:
				break
		if count == 1:
			var x = int(last_empty_cell.x)
			var y = int(last_empty_cell.y)
			candidates[x][y] = [num]  # Update the cell to contain only this candidate
			updated = true
	return updated

# Helper function to check and fill Full House in a 3x3 box
func _check_full_house_box(candidates: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3

	for num in range(1, 10):
		var count = 0
		var last_empty_cell = Vector2()
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				var cell_candidates = candidates[cell_row][cell_col]
				if typeof(cell_candidates) == TYPE_ARRAY and num in cell_candidates:
					last_empty_cell = Vector2(cell_row, cell_col)
					count += 1
				if count > 1:
					break
			if count > 1:
				break
		if count == 1:
			var x = int(last_empty_cell.x)
			var y = int(last_empty_cell.y)
			candidates[x][y] = [num]  # Update the cell to contain only this candidate
			updated = true
	return updated
