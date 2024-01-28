#LockedCandidates.gd
extends Node

# Function to solve Sudoku using the Locked Candidates technique
func solve(candidates: Array) -> Array:
	#print("LockedCandidates")
	#var check = candidates.duplicate(true)

	# Apply Locked Candidates technique for each box
	for box in range(9):
		locked_candidates(candidates, box)

#	if check != candidates:
#		print("LockedCandidates used")
	return candidates

# Locked Candidates for a single box
func locked_candidates(candidates: Array, box: int):
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3

	# Check each number 1-9 in the box
	for num in range(1, 10):
		var rows_with_num = []
		var cols_with_num = []

		# Find rows and columns within the box where the number appears
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				if num in candidates[cell_row][cell_col]:
					rows_with_num.append(cell_row)
					cols_with_num.append(cell_col)

		# If the number is confined to a single row or column, remove it from other cells in that row or column outside the box
		rows_with_num = remove_duplicates(rows_with_num)
		cols_with_num = remove_duplicates(cols_with_num)

		if rows_with_num.size() == 1:
			remove_num_from_row_outside_box(candidates, rows_with_num[0], start_col, num)
		if cols_with_num.size() == 1:
			remove_num_from_col_outside_box(candidates, cols_with_num[0], start_row, num)

# Helper functions
func remove_duplicates(arr):
	var unique = []
	for item in arr:
		if not unique.has(item):
			unique.append(item)
	return unique

func remove_num_from_row_outside_box(candidates, row, box_start_col, num):
	for col in range(9):
		if col < box_start_col or col >= box_start_col + 3:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)

func remove_num_from_col_outside_box(candidates, col, box_start_row, num):
	for row in range(9):
		if row < box_start_row or row >= box_start_row + 3:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)
