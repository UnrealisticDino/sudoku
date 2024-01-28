#XWing.gd
extends Node

# Function to solve Sudoku using the X-Wing technique
func solve(candidates: Array) -> Array:
	#print("X-Wing")
	#var check = candidates.duplicate(true)

	# Apply X-Wing technique for each number
	for num in range(1, 10):
		check_x_wing(candidates, num)

#	if check != candidates:
#		print("X-Wing used")
	return candidates

# Check and apply X-Wing for a specific number
func check_x_wing(candidates: Array, num: int):
	# Check for X-Wing in rows
	check_x_wing_in_rows(candidates, num)
	# Check for X-Wing in columns
	check_x_wing_in_cols(candidates, num)

# Check and apply X-Wing in rows
func check_x_wing_in_rows(candidates: Array, num: int):
	var row_candidates = []
	for row in range(9):
		var cols = []
		for col in range(9):
			if num in candidates[row][col]:
				cols.append(col)
		if cols.size() == 2:
			row_candidates.append({"row": row, "cols": cols})

	apply_x_wing(candidates, row_candidates, num, true)

# Check and apply X-Wing in columns
func check_x_wing_in_cols(candidates: Array, num: int):
	var col_candidates = []
	for col in range(9):
		var rows = []
		for row in range(9):
			if num in candidates[row][col]:
				rows.append(row)
		if rows.size() == 2:
			col_candidates.append({"col": col, "rows": rows})

	apply_x_wing(candidates, col_candidates, num, false)

# Apply the X-Wing technique
func apply_x_wing(candidates: Array, candidates_list: Array, num: int, is_row_based: bool):
	for i in range(candidates_list.size()):
		for j in range(i + 1, candidates_list.size()):
			var first = candidates_list[i]
			var second = candidates_list[j]

			if is_row_based and first["cols"] == second["cols"]:
				# X-Wing found in rows
				for col in first["cols"]:
					remove_num_from_other_cells_in_col(candidates, col, [first["row"], second["row"]], num)
			elif not is_row_based and first["rows"] == second["rows"]:
				# X-Wing found in columns
				for row in first["rows"]:
					remove_num_from_other_cells_in_row(candidates, row, [first["col"], second["col"]], num)

# Remove a number from other cells in the specified column
func remove_num_from_other_cells_in_col(candidates: Array, col: int, exception_rows: Array, num: int):
	for row in range(9):
		if not row in exception_rows:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)

# Remove a number from other cells in the specified row
func remove_num_from_other_cells_in_row(candidates: Array, row: int, exception_cols: Array, num: int):
	for col in range(9):
		if not col in exception_cols:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)
