#HiddenTriples.gd
extends Node

# Function to solve Hidden Triples in the candidates array
func solve(candidates: Array) -> Array:
	#print("HiddenTriples")
	#var check = candidates.duplicate(true)
	var updated = false

	# Check each row, column, and box for Hidden Triples
	for i in range(9):
		updated = check_hidden_triples_unit(candidates, i, true) or updated  # Check rows
		updated = check_hidden_triples_unit(candidates, i, false) or updated  # Check columns
		updated = check_hidden_triples_box(candidates, i) or updated  # Check boxes

#	if check != candidates:
#		print("HiddenTriples used")

	return candidates

# Helper function to check and resolve Hidden Triples in a row or column
func check_hidden_triples_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var potential_cells = []

	# Find cells with 2 or 3 candidates
	for i in range(9):
		var cell = candidates[index][i] if is_row else candidates[i][index]
		if cell.size() in [2, 3]:
			potential_cells.append({'cell': cell, 'pos': i})

	# Check combinations of three cells
	for i in range(potential_cells.size()):
		for j in range(i + 1, potential_cells.size()):
			for k in range(j + 1, potential_cells.size()):
				var combined = potential_cells[i]['cell'] + potential_cells[j]['cell'] + potential_cells[k]['cell']
				combined = remove_duplicates(combined)
				if combined.size() == 3:
					updated = eliminate_others(candidates, index, is_row, combined, [potential_cells[i]['pos'], potential_cells[j]['pos'], potential_cells[k]['pos']]) or updated
	return updated

# Helper function to check and resolve Hidden Triples in a 3x3 box
func check_hidden_triples_box(candidates: Array, box: int) -> bool:
	var updated = false
	var potential_cells = []
	var startRow = (box / 3) * 3
	var startCol = (box % 3) * 3

	# Find cells with 2 or 3 candidates within the box
	for row in range(startRow, startRow + 3):
		for col in range(startCol, startCol + 3):
			var cell = candidates[row][col]
			if cell.size() in [2, 3]:
				potential_cells.append({'cell': cell, 'pos': Vector2(row, col)})

	# Check combinations of three cells
	for i in range(potential_cells.size()):
		for j in range(i + 1, potential_cells.size()):
			for k in range(j + 1, potential_cells.size()):
				var combined = potential_cells[i]['cell'] + potential_cells[j]['cell'] + potential_cells[k]['cell']
				combined = remove_duplicates(combined)
				if combined.size() == 3:
					updated = eliminate_from_box(candidates, startRow, startCol, combined, [potential_cells[i]['pos'], potential_cells[j]['pos'], potential_cells[k]['pos']]) or updated
	return updated

# Function to eliminate candidates from cells outside the found triple in a box
func eliminate_from_box(candidates: Array, startRow: int, startCol: int, triple: Array, positions: Array) -> bool:
	var updated = false
	for row in range(startRow, startRow + 3):
		for col in range(startCol, startCol + 3):
			var pos = Vector2(row, col)
			var cell = candidates[row][col]
			if pos in positions:
				# For cells that are part of the Hidden Triple, only remove candidates not in the triple
				var cell_updated = false
				for num in cell.duplicate():
					if not triple.has(num):
						cell.erase(num)
						cell_updated = true
				updated = updated or cell_updated
			elif cell.size() > 1:
				# For other cells, remove all candidates that are part of the triple
				for num in triple:
					if num in cell:
						cell.erase(num)
						updated = true
	return updated

# Function to eliminate candidates from cells outside the found triple in a row or column
func eliminate_others(candidates: Array, index: int, is_row: bool, triple: Array, positions: Array) -> bool:
	var updated = false
	for i in range(9):
		var cell = candidates[index][i] if is_row else candidates[i][index]
		if positions.has(i):
			# For cells that are part of the Hidden Triple, only remove candidates not in the triple
			var cell_updated = false
			for num in cell.duplicate():
				if not triple.has(num):
					cell.erase(num)
					cell_updated = true
			updated = updated or cell_updated
		elif cell.size() > 1:
			# For other cells, remove all candidates that are part of the triple
			for num in triple:
				if num in cell:
					cell.erase(num)
					updated = true
	return updated

# Function to remove duplicates from an array
func remove_duplicates(arr: Array) -> Array:
	var unique_dict = {}
	for item in arr:
		unique_dict[item] = null
	return unique_dict.keys()
