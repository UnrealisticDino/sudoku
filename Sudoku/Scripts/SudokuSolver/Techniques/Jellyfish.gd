#Jellyfish.gd
extends Node

# Function to solve Sudoku using the Jellyfish technique
func solve(candidates: Array) -> Array:
	#print("Jellyfish")
	#var check = candidates.duplicate(true)

	# Apply Jellyfish technique for each number
	for num in range(1, 10):
		check_jellyfish(candidates, num)

#	if check != candidates:
#		print("Jellyfish used")
	return candidates

# Check and apply Jellyfish for a specific number
func check_jellyfish(candidates: Array, num: int):
	# Check for Jellyfish in rows
	check_jellyfish_in_rows(candidates, num)
	# Check for Jellyfish in columns
	check_jellyfish_in_cols(candidates, num)

# Check and apply Jellyfish in rows
func check_jellyfish_in_rows(candidates: Array, num: int):
	var row_candidates = []
	for row in range(9):
		var cols = []
		for col in range(9):
			if num in candidates[row][col]:
				cols.append(col)
		if cols.size() >= 2 and cols.size() <= 4:
			row_candidates.append({"row": row, "cols": cols})

	apply_jellyfish(candidates, row_candidates, num, true)

# Check and apply Jellyfish in columns
func check_jellyfish_in_cols(candidates: Array, num: int):
	var col_candidates = []
	for col in range(9):
		var rows = []
		for row in range(9):
			if num in candidates[row][col]:
				rows.append(row)
		if rows.size() >= 2 and rows.size() <= 4:
			col_candidates.append({"col": col, "rows": rows})

	apply_jellyfish(candidates, col_candidates, num, false)

# Apply the Jellyfish technique
func apply_jellyfish(candidates: Array, candidates_list: Array, num: int, is_row_based: bool):
	for i in range(candidates_list.size()):
		for j in range(i + 1, candidates_list.size()):
			for k in range(j + 1, candidates_list.size()):
				for l in range(k + 1, candidates_list.size()):
					var first = candidates_list[i]
					var second = candidates_list[j]
					var third = candidates_list[k]
					var fourth = candidates_list[l]

					if is_row_based:
						var cols = first["cols"] + second["cols"] + third["cols"] + fourth["cols"]
						cols = remove_duplicates(cols)
						if cols.size() == 4:
							# Jellyfish found in rows
							for col in cols:
								remove_num_from_other_cells_in_col(candidates, col, [first["row"], second["row"], third["row"], fourth["row"]], num)
					else:
						var rows = first["rows"] + second["rows"] + third["rows"] + fourth["rows"]
						rows = remove_duplicates(rows)
						if rows.size() == 4:
							# Jellyfish found in columns
							for row in rows:
								remove_num_from_other_cells_in_row(candidates, row, [first["col"], second["col"], third["col"], fourth["col"]], num)

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
