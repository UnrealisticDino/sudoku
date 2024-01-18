#HiddenTriples.gd
extends Node

class_name HiddenTriplesSolver

# Function to solve Hidden Triples in a Sudoku grid
func solve(grid: Array) -> Array:
	print("HiddenTriples")
	var updated = false

	# Check each row, column, and box for Hidden Triples
	for i in range(9):
		updated = check_hidden_triples_unit(grid, i, true) or updated  # Check rows
		updated = check_hidden_triples_unit(grid, i, false) or updated  # Check columns
		updated = check_hidden_triples_box(grid, i) or updated  # Check boxes

	return grid

# Helper function to check and resolve Hidden Triples in a row or column
func check_hidden_triples_unit(grid: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var potential_cells = []
	
	# Find cells with 2 or 3 candidates
	for i in range(9):
		var cell = grid[index][i] if is_row else grid[i][index]
		if cell is Array and cell.size() in [2, 3]:
			potential_cells.append({'cell': cell, 'pos': i})

	# Check combinations of three cells
	for i in range(potential_cells.size()):
		for j in range(i + 1, potential_cells.size()):
			for k in range(j + 1, potential_cells.size()):
				var combined = potential_cells[i]['cell'] + potential_cells[j]['cell'] + potential_cells[k]['cell']
				combined = combined.deduplicate()
				if combined.size() == 3:
					# Found a hidden triple, eliminate other candidates
					updated = eliminate_others(grid, index, is_row, combined, [potential_cells[i]['pos'], potential_cells[j]['pos'], potential_cells[k]['pos']]) or updated
	return updated

# Helper function to check and resolve Hidden Triples in a 3x3 box
func check_hidden_triples_box(grid: Array, box: int) -> bool:
	var updated = false
	var potential_cells = []
	var startRow = (box / 3) * 3
	var startCol = (box % 3) * 3

	# Find cells with 2 or 3 candidates within the box
	for row in range(startRow, startRow + 3):
		for col in range(startCol, startCol + 3):
			var cell = grid[row][col]
			if cell is Array and cell.size() in [2, 3]:
				potential_cells.append({'cell': cell, 'pos': Vector2(row, col)})

	# Check combinations of three cells
	for i in range(potential_cells.size()):
		for j in range(i + 1, potential_cells.size()):
			for k in range(j + 1, potential_cells.size()):
				var combined = potential_cells[i]['cell'] + potential_cells[j]['cell'] + potential_cells[k]['cell']
				combined = combined.deduplicate()
				if combined.size() == 3:
					# Found a hidden triple, eliminate other candidates
					var positions = [potential_cells[i]['pos'], potential_cells[j]['pos'], potential_cells[k]['pos']]
					for row in range(startRow, startRow + 3):
						for col in range(startCol, startCol + 3):
							if not Vector2(row, col) in positions:
								updated = eliminate_from_cell(grid, row, col, combined) or updated
	return updated

func eliminate_from_cell(grid: Array, row: int, col: int, numbers: Array) -> bool:
	var updated = false
	var cell = grid[row][col]
	if cell is Array:
		for num in cell:
			if num in numbers:
				cell.erase(num)
				updated = true
	return updated

func eliminate_others(grid: Array, index: int, is_row: bool, triple: Array, positions: Array) -> bool:
	var updated = false
	for pos in positions:
		var cell = grid[index][pos] if is_row else grid[pos][index]
		if cell is Array:
			for num in cell:
				if not num in triple:
					cell.erase(num)
					updated = true
	return updated
