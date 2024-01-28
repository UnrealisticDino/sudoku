#NakedQuads.gd
extends Node

# Function to apply the Naked Quads technique to the Sudoku candidates
func solve(candidates):
	#print("NakedQuads")
	#var check = candidates.duplicate(true)

	# Apply Naked Quads technique for each row, column, and box
	for i in range(9):
		apply_naked_quads(candidates, get_row_candidates(candidates, i))
		apply_naked_quads(candidates, get_column_candidates(candidates, i))
		apply_naked_quads(candidates, get_box_candidates(candidates, i))

#	if check != candidates:
#		print("NakedQuads used")
	return candidates

# Extracts the candidates for a specific row
func get_row_candidates(candidates, row_number):
	var row = []
	for col in range(9):
		row.append(candidates[row_number][col])
	return row

# Extracts the candidates for a specific column
func get_column_candidates(candidates, col_number):
	var column = []
	for row in range(9):
		column.append(candidates[row][col_number])
	return column

# Extracts the candidates for a specific 3x3 box
func get_box_candidates(candidates, box_number):
	var box = []
	var start_row = (box_number / 3) * 3
	var start_col = (box_number % 3) * 3
	for i in range(3):
		for j in range(3):
			box.append(candidates[start_row + i][start_col + j])
	return box

# Applies the Naked Quads technique to a unit (row, column, or box)
func apply_naked_quads(candidates, unit):
	var progress = false
	var candidate_sets = []
	for cell_candidates in unit:
		if cell_candidates.size() >= 2 and cell_candidates.size() <= 4:
			candidate_sets.append(cell_candidates)

	# Look for naked quads
	for i in range(candidate_sets.size()):
		for j in range(i + 1, candidate_sets.size()):
			for k in range(j + 1, candidate_sets.size()):
				for l in range(k + 1, candidate_sets.size()):
					var combined_candidates = candidate_sets[i] + candidate_sets[j] + candidate_sets[k] + candidate_sets[l]
					combined_candidates = remove_duplicates(combined_candidates)
					if combined_candidates.size() == 4:
						# Found a naked quad, eliminate these candidates from other cells in the unit
						for cell_candidates in unit:
							if cell_candidates != candidate_sets[i] and cell_candidates != candidate_sets[j] and cell_candidates != candidate_sets[k] and cell_candidates != candidate_sets[l]:
								for candidate in combined_candidates:
									if candidate in cell_candidates:
										cell_candidates.erase(candidate)
										progress = true
	return progress

# Function to remove duplicates from an array
func remove_duplicates(arr):
	var unique = []
	for item in arr:
		if not item in unique:
			unique.append(item)
	return unique
