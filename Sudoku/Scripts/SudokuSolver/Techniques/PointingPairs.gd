#PointingPairs.gd
extends Node

# Function to solve Pointing Pairs in a Sudoku puzzle
func solve(candidates: Array) -> Array:
	#print("PointingPairs")
	#var check = candidates.duplicate(true)

	for block_row in range(3):
		for block_col in range(3):
			var block_pointing_pairs = find_pointing_pairs_in_block(candidates, block_row, block_col)
			candidates = apply_pointing_pairs(candidates, block_pointing_pairs)

#	if check != candidates:
#		print("PointingPairs used")
	return candidates

# Find pointing pairs in a 3x3 block
func find_pointing_pairs_in_block(candidates: Array, block_row: int, block_col: int) -> Dictionary:
	var pointing_pairs = {}
	for num in range(1, 10):
		var cells = []
		for row in range(block_row * 3, block_row * 3 + 3):
			for col in range(block_col * 3, block_col * 3 + 3):
				if num in candidates[row][col]:
					cells.append({"row": row, "col": col})

		if cells.size() == 2:
			var same_row = cells[0]["row"] == cells[1]["row"]
			var same_col = cells[0]["col"] == cells[1]["col"]
			
			if same_row or same_col:
				pointing_pairs[num] = cells

	return pointing_pairs

# Apply the pointing pairs findings to the candidates array
func apply_pointing_pairs(candidates: Array, pointing_pairs: Dictionary) -> Array:
	for num in pointing_pairs.keys():
		var cells = pointing_pairs[num]
		if cells.size() == 2:
			var common_row = cells[0]["row"] == cells[1]["row"]
			var common_col = cells[0]["col"] == cells[1]["col"]

			if common_row:
				var row = cells[0]["row"]
				for col in range(9):
					if not is_col_in_cells(col, cells):
						if num in candidates[row][col]:
							candidates[row][col].erase(num)

			if common_col:
				var col = cells[0]["col"]
				for row in range(9):
					if not is_row_in_cells(row, cells):
						if num in candidates[row][col]:
							candidates[row][col].erase(num)

	return candidates

# Helper function to check if a column is in a list of cells
func is_col_in_cells(col: int, cells: Array) -> bool:
	for cell in cells:
		if cell["col"] == col:
			return true
	return false

# Helper function to check if a row is in a list of cells
func is_row_in_cells(row: int, cells: Array) -> bool:
	for cell in cells:
		if cell["row"] == row:
			return true
	return false
