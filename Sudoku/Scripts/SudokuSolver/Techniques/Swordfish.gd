#Swordfish.gd
extends Node

# Function to solve Sudoku using the Swordfish technique
func solve(candidates: Array) -> Array:
	#print("Swordfish")
	#var check = candidates.duplicate(true)

	# Apply Swordfish technique for each number
	for num in range(1, 10):
		check_swordfish(candidates, num)

#	if check != candidates:
#		print("Swordfish used")
	return candidates

# Check and apply Swordfish for a specific number
func check_swordfish(candidates: Array, num: int):
	# Check for Swordfish in rows
	check_swordfish_in_rows(candidates, num)
	# Check for Swordfish in columns
	check_swordfish_in_cols(candidates, num)

# Check and apply Swordfish in rows
func check_swordfish_in_rows(candidates: Array, num: int):
	var row_candidates = []
	for row in range(9):
		var cols = []
		for col in range(9):
			if num in candidates[row][col]:
				cols.append(col)
		if cols.size() >= 2 and cols.size() <= 3:
			row_candidates.append({"row": row, "cols": cols})

	apply_swordfish(candidates, row_candidates, num, true)

# Check and apply Swordfish in columns
func check_swordfish_in_cols(candidates: Array, num: int):
	var col_candidates = []
	for col in range(9):
		var rows = []
		for row in range(9):
			if num in candidates[row][col]:
				rows.append(row)
		if rows.size() >= 2 and rows.size() <= 3:
			col_candidates.append({"col": col, "rows": rows})

	apply_swordfish(candidates, col_candidates, num, false)

# Apply the Swordfish technique
func apply_swordfish(candidates: Array, candidates_list: Array, num: int, is_row_based: bool):
	for i in range(candidates_list.size()):
		for j in range(i + 1, candidates_list.size()):
			for k in range(j + 1, candidates_list.size()):
				var first = candidates_list[i]
				var second = candidates_list[j]
				var third = candidates_list[k]

				if is_row_based:
					var cols = first["cols"] + second["cols"] + third["cols"]
					cols = remove_duplicates(cols)
					if cols.size() == 3:
						# Swordfish found in rows
						for col in cols:
							remove_num_from_other_cells_in_col(candidates, col, [first["row"], second["row"], third["row"]], num)
				else:
					var rows = first["rows"] + second["rows"] + third["rows"]
					rows = remove_duplicates(rows)
					if rows.size() == 3:
						# Swordfish found in columns
						for row in rows:
							remove_num_from_other_cells_in_row(candidates, row, [first["col"], second["col"], third["col"]], num)

# Helper functions
func remove_duplicates(arr):
	var unique = []
	for item in arr:
		if not unique.has(item):
			unique.append(item)
	return unique

func remove_num_from_other_cells_in_col(candidates: Array, col: int, exception_rows: Array, num: int):
	for row in range(9):
		if not row in exception_rows:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)

func remove_num_from_other_cells_in_row(candidates: Array, row: int, exception_cols: Array, num: int):
	for col in range(9):
		if not col in exception_cols:
			if num in candidates[row][col]:
				candidates[row][col].erase(num)
