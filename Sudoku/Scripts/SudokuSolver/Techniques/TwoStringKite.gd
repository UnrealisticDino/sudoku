#TwoStringKite.gd
extends Node

# Function to solve Sudoku using the Two-String Kite technique
func solve(candidates: Array) -> Array:
	#print("Two-String Kite")
	var check = candidates.duplicate(true)

	# Apply Two-String Kite technique for each number
	for num in range(1, 10):
		two_string_kite(candidates, num)

	if check != candidates:
		print("Two-String Kite used")
	return candidates

# Two-String Kite technique for a single number
func two_string_kite(candidates: Array, num: int):
	# Check each combination of rows and columns
	for row in range(9):
		for col in range(9):
			var positions_row = find_num_positions(candidates, num, row, true)
			var positions_col = find_num_positions(candidates, num, col, false)

			# Find kite pattern
			if positions_row.size() == 2 and positions_col.size() == 2:
				var common = find_common_unit(positions_row, positions_col)
				if common != Vector2(-1, -1):
					# Kite pattern found, eliminate candidate
					eliminate_kite_candidates(candidates, num, common, positions_row, positions_col)

func find_num_positions(candidates: Array, num: int, line: int, isRow: bool) -> Array:
	var positions = []
	for i in range(9):
		if isRow:
			if num in candidates[line][i]:
				positions.append(Vector2(line, i))
		else:
			if num in candidates[i][line]:
				positions.append(Vector2(i, line))
	return positions

func find_common_unit(positions1: Array, positions2: Array) -> Vector2:
	for pos1 in positions1:
		for pos2 in positions2:
			if pos1.x == pos2.x or pos1.y == pos2.y:
				return Vector2(pos1.x, pos1.y)
	return Vector2(-1, -1)

func eliminate_kite_candidates(candidates: Array, num: int, common: Vector2, positions_row: Array, positions_col: Array):
	# Eliminate candidate in the cell seen by both ends of the kite
	for pos in positions_row:
		if pos != common and num in candidates[pos.x][pos.y]:
			candidates[pos.x][pos.y].erase(num)
	for pos in positions_col:
		if pos != common and num in candidates[pos.x][pos.y]:
			candidates[pos.x][pos.y].erase(num)
