#NakedTriples.gd
extends Node

class_name NakedTriplesSolver

# Function to solve Naked Triples in a Sudoku grid
func solve(grid: Array) -> Array:
	print("NakedTriples")
	var updated = false

	# Check each row, column, and box for Naked Triples
	for i in range(9):
		updated = check_naked_triples_unit(grid, i, true) or updated  # Check rows
		updated = check_naked_triples_unit(grid, i, false) or updated  # Check columns
		updated = check_naked_triples_box(grid, i) or updated  # Check boxes

	return grid

# Helper function to check and resolve Naked Triples in a row or column
func check_naked_triples_unit(grid: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var cell_groups = get_cell_groups(grid, index, is_row)  # You need to implement this

	for i in range(cell_groups.size()):
		for j in range(i + 1, cell_groups.size()):
			for k in range(j + 1, cell_groups.size()):
				var combined = cell_groups[i] + cell_groups[j] + cell_groups[k]
				combined = combined.deduplicate()  # Removes duplicates from the array

				if combined.size() == 3:
					# Found a naked triple, now eliminate these numbers from other cells
					updated = eliminate_numbers(grid, index, is_row, combined, [i, j, k]) or updated  # Implement this

	return updated

# Helper function to check and resolve Naked Triples in a 3x3 box
func check_naked_triples_box(grid: Array, box: int) -> bool:
	var updated = false
	var cell_groups = get_box_cell_groups(grid, box)

	# Iterate through all combinations of three cells in the cell_groups
	for i in range(cell_groups.size()):
		for j in range(i + 1, cell_groups.size()):
			for k in range(j + 1, cell_groups.size()):
				var combined = cell_groups[i] + cell_groups[j] + cell_groups[k]
				combined = combined.deduplicate()  # Removes duplicates from the array

				# Check if the combined group forms a naked triple
				if combined.size() == 3:
					# Found a naked triple, now eliminate these numbers from other cells in the box
					updated = eliminate_numbers_from_box(grid, box, combined, [i, j, k]) or updated

	return updated

func eliminate_numbers_from_box(grid: Array, box: int, numbers: Array, exceptions: Array) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3

	for row in range(start_row, start_row + 3):
		for col in range(start_col, start_col + 3):
			if not ([row, col] in exceptions):
				var cell = grid[row][col]
				if cell is Array:
					for number in numbers:
						if number in cell:
							cell.erase(number)
							updated = true

	return updated

func get_box_cell_groups(grid: Array, box: int) -> Array:
	var cell_groups = []
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3

	for row in range(start_row, start_row + 3):
		for col in range(start_col, start_col + 3):
			var cell = grid[row][col]
			if cell is Array:
				cell_groups.append(cell)
	return cell_groups

func get_cell_groups(grid: Array, index: int, is_row: bool) -> Array:
	var cell_groups = []
	for i in range(9):
		var cell
		if is_row:
			cell = grid[index][i]
		else:
			cell = grid[i][index]
		
		if cell is Array:  # Assuming a cell with multiple candidates is an Array
			cell_groups.append(cell)
	return cell_groups

func eliminate_numbers(grid: Array, index: int, is_row: bool, numbers: Array, exceptions: Array) -> bool:
	var updated = false
	for i in range(9):
		if not (i in exceptions):
			var cell
			if is_row:
				cell = grid[index][i]
			else:
				cell = grid[i][index]

			if cell is Array:
				for number in numbers:
					if number in cell:
						cell.erase(number)
						updated = true
	return updated
