#FullHouse.gd
extends Node

# Function to solve Full House in a Sudoku grid
func solve(grid: Array) -> Array:
	print("FullHouse")
	var updated = false

	# Check each row, column, and box for Full House
	for i in range(9):
		if _check_full_house_row(grid, i) or _check_full_house_col(grid, i) or _check_full_house_box(grid, i):
			updated = true
			break  # Exit the loop early if a change is made

	if updated:
		return grid
	else:
		return grid.duplicate()  # Return a duplicate to indicate no changes

# Helper function to check and fill Full House in a row
func _check_full_house_row(grid: Array, row: int) -> bool:
	return _check_full_house_unit(grid, row, true)

# Helper function to check and fill Full House in a column
func _check_full_house_col(grid: Array, col: int) -> bool:
	return _check_full_house_unit(grid, col, false)

# Helper function to check and fill Full House in a 3x3 box
func _check_full_house_box(grid: Array, box: int) -> bool:
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	for num in range(1, 10):
		var count = 0
		var last_empty_cell = Vector2()
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				if grid[cell_row][cell_col] == 0:
					last_empty_cell = Vector2(cell_row, cell_col)
					count += 1
				elif grid[cell_row][cell_col] == num:
					count = -1
					break
			if count < 0:
				break
		if count == 1:
			grid[int(last_empty_cell.x)][int(last_empty_cell.y)] = num
			return true
	return false

# General helper function to check and fill Full House in a row or column
func _check_full_house_unit(grid: Array, index: int, is_row: bool) -> bool:
	for num in range(1, 10):
		var count = 0
		var last_empty_cell = Vector2()
		for i in range(9):
			var cell_value = grid[index][i] if is_row else grid[i][index]
			if cell_value == 0:
				last_empty_cell = Vector2(index, i) if is_row else Vector2(i, index)
				count += 1
			elif cell_value == num:
				count = -1
				break
		if count == 1:
			grid[int(last_empty_cell.x)][int(last_empty_cell.y)] = num
			return true
	return false
