#PointingTriples.gd
extends Node

# Function to solve Pointing Triples in a Sudoku puzzle
func solve(candidates: Array) -> Array:
	#print("PointingTriples")
	#var check = candidates.duplicate(true)

	for block_row in range(3):
		for block_col in range(3):
			var block_pointing_triples = find_pointing_triples_in_block(candidates, block_row, block_col)
			candidates = apply_pointing_triples(candidates, block_pointing_triples)

#	if check != candidates:
#		print("PointingTriples used")
	return candidates

# Find pointing triples in a 3x3 block
func find_pointing_triples_in_block(candidates: Array, block_row: int, block_col: int) -> Dictionary:
	var pointing_triples = {}
	for num in range(1, 10):
		var cells = []
		for row in range(block_row * 3, block_row * 3 + 3):
			for col in range(block_col * 3, block_col * 3 + 3):
				if num in candidates[row][col]:
					cells.append({"row": row, "col": col})

		# Check if the cells are in the same row or column
		var same_row = all_cells_in_same_row(cells)
		var same_col = all_cells_in_same_col(cells)

		if (same_row or same_col) and cells.size() <= 3:
			pointing_triples[num] = cells

	return pointing_triples

# Apply the pointing triples findings to the candidates array
func apply_pointing_triples(candidates: Array, pointing_triples: Dictionary) -> Array:
	for num in pointing_triples.keys():
		var cells = pointing_triples[num]
		if cells.size() == 3:
			var common_row = all_cells_in_same_row(cells)
			var common_col = all_cells_in_same_col(cells)

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

# Helper functions
func all_cells_in_same_row(cells: Array) -> bool:
	var row = cells[0]["row"]
	for cell in cells:
		if cell["row"] != row:
			return false
	return true

func all_cells_in_same_col(cells: Array) -> bool:
	var col = cells[0]["col"]
	for cell in cells:
		if cell["col"] != col:
			return false
	return true

func is_col_in_cells(col: int, cells: Array) -> bool:
	for cell in cells:
		if cell["col"] == col:
			return true
	return false

func is_row_in_cells(row: int, cells: Array) -> bool:
	for cell in cells:
		if cell["row"] == row:
			return true
	return false
