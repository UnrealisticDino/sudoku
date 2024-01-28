#FinnedXWing.gd
extends Node

# Function to solve Sudoku using the Finned X-Wing technique
func solve(candidates: Array) -> Array:
	#print("Finned X-Wing")
	var check = candidates.duplicate(true)

	# Apply Finned X-Wing technique for each number
	for num in range(1, 10):
		finned_x_wing(candidates, num)

	if check != candidates:
		print("Finned X-Wing used")
	return candidates

# Finned X-Wing technique for a single number
func finned_x_wing(candidates: Array, num: int):
	# Check for Finned X-Wing in rows
	for row1 in range(9):
		for row2 in range(row1 + 1, 9):
			check_finned_x_wing(candidates, num, row1, row2, true) # true for rows
	# Check for Finned X-Wing in columns
	for col1 in range(9):
		for col2 in range(col1 + 1, 9):
			check_finned_x_wing(candidates, num, col1, col2, false) # false for columns

func check_finned_x_wing(candidates: Array, num: int, line1: int, line2: int, isRow: bool):
	var positions1 = find_num_positions(candidates, num, line1, isRow)
	var positions2 = find_num_positions(candidates, num, line2, isRow)

	# Check for classic X-Wing pattern first
	if positions1.size() == 2 and positions2.size() == 2:
		# Classic X-Wing found, no need to check for fins
		return

	# Check for Finned X-Wing
	if (positions1.size() == 3 and positions2.size() == 2) or (positions1.size() == 2 and positions2.size() == 3):
		var fin_positions = positions1.size() == 3 if positions1 else positions2
		var x_wing_positions = positions1.size() == 2 if positions1 else positions2
		var fin_box = get_box_of_fin(fin_positions, x_wing_positions)

		# If a fin is found in a box, eliminate candidates
		if fin_box != -1:
			eliminate_candidates_outside_fin_box(candidates, num, fin_box, isRow)

func find_num_positions(candidates: Array, num: int, line: int, isRow: bool) -> Array:
	var positions = []
	for i in range(9):
		if isRow and num in candidates[line][i]:
			positions.append(Vector2(line, i))
		elif not isRow and num in candidates[i][line]:
			positions.append(Vector2(i, line))
	return positions

func get_box_of_fin(fin_positions: Array, x_wing_positions: Array) -> int:
	for fin_pos in fin_positions:
		if not x_wing_positions.has(fin_pos):
			return int(fin_pos.x / 3) * 3 + int(fin_pos.y / 3)
	return -1

func eliminate_candidates_outside_fin_box(candidates: Array, num: int, fin_box: int, isRow: bool):
	for row in range(9):
		for col in range(9):
			if isRow and int(col / 3) != fin_box % 3:
				continue
			if not isRow and int(row / 3) != int(fin_box / 3):
				continue
			if num in candidates[row][col]:
				candidates[row][col].erase(num)
