#NakedTriples.gd
extends Node

# Function to solve Naked Triples in the candidates array
func solve(candidates: Array) -> Array:
	#print("NakedTriples")
	#var check = candidates.duplicate(true)
	var updated = false

	for i in range(9):
		updated = check_naked_triples_unit(candidates, i, true) or updated  # Check rows
		updated = check_naked_triples_unit(candidates, i, false) or updated  # Check columns
		updated = check_naked_triples_box(candidates, i) or updated  # Check boxes

#	if check != candidates:
#		print("NakedTriples used")

	return candidates

# Helper function to check and resolve Naked Triples in a row or column
func check_naked_triples_unit(candidates: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var cell_groups = get_cell_groups(candidates, index, is_row)

	for i in range(cell_groups.size()):
		for j in range(i + 1, cell_groups.size()):
			for k in range(j + 1, cell_groups.size()):
				var combined = cell_groups[i] + cell_groups[j] + cell_groups[k]
				combined = remove_duplicates(combined)

				if combined.size() == 3:
					updated = eliminate_numbers(candidates, index, is_row, combined, [i, j, k]) or updated

	return updated

# Helper function to check and resolve Naked Triples in a 3x3 box
func check_naked_triples_box(candidates: Array, box: int) -> bool:
	var updated = false
	var cell_groups = get_box_cell_groups(candidates, box)

	for i in range(cell_groups.size()):
		for j in range(i + 1, cell_groups.size()):
			for k in range(j + 1, cell_groups.size()):
				var combined = cell_groups[i] + cell_groups[j] + cell_groups[k]
				combined = remove_duplicates(combined)

				if combined.size() == 3:
					updated = eliminate_numbers_from_box(candidates, box, combined, [i, j, k]) or updated

	return updated

# Function to get candidate groups for each cell in a unit (row or column)
func get_cell_groups(candidates: Array, index: int, is_row: bool) -> Array:
	var cell_groups = []
	for i in range(9):
		var cell = candidates[index][i] if is_row else candidates[i][index]
		if cell.size() > 1:  # Ignore cells with a single candidate
			cell_groups.append(cell)
	return cell_groups

# Function to get candidate groups for each cell in a 3x3 box
func get_box_cell_groups(candidates: Array, box: int) -> Array:
	var cell_groups = []
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	for i in range(3):
		for j in range(3):
			var cell = candidates[start_row + i][start_col + j]
			if cell.size() > 1:  # Ignore cells with a single candidate
				cell_groups.append(cell)
	return cell_groups

# Function to eliminate numbers from candidates in a row or column
func eliminate_numbers(candidates: Array, index: int, is_row: bool, numbers: Array, exceptions: Array) -> bool:
	var updated = false
	for i in range(9):
		if not exceptions.has(i):
			var cell = candidates[index][i] if is_row else candidates[i][index]
			if cell.size() > 1 and (cell.size() - numbers.size() >= 1):
				for number in numbers:
					if number in cell:
						cell.erase(number)
						updated = true

	return updated

# Function to eliminate numbers from candidates in a 3x3 box
func eliminate_numbers_from_box(candidates: Array, box: int, numbers: Array, exceptions: Array) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	for i in range(3):
		for j in range(3):
			var pos = Vector2(start_row + i, start_col + j)
			if not exceptions.has(pos):
				var cell = candidates[pos.x][pos.y]
				if cell.size() > 1 and (cell.size() - numbers.size() >= 1):
					for number in numbers:
						if number in cell:
							cell.erase(number)
							updated = true
	return updated

# Function to remove duplicates from an array
func remove_duplicates(arr: Array) -> Array:
	var unique_dict = {}
	for item in arr:
		unique_dict[item] = null
	return unique_dict.keys()
