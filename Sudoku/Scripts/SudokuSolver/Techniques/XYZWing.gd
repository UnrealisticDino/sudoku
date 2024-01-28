#XYZWing.gd
extends Node

# Function to solve Sudoku using the XYZ-Wing technique
func solve(candidates: Array) -> Array:
	#print("XYZ-Wing")
	var check = candidates.duplicate(true)

	# Apply XYZ-Wing technique
	xyz_wing(candidates)

	if check != candidates:
		print("XYZ-Wing used")
	return candidates

# XYZ-Wing technique
func xyz_wing(candidates: Array):
	for row in range(9):
		for col in range(9):
			var cell_candidates = candidates[row][col]
			if cell_candidates.size() == 3:
				# Check for hinge cell
				check_xyz_wing(candidates, Vector2(row, col), cell_candidates)

func check_xyz_wing(candidates: Array, hinge_pos: Vector2, hinge_candidates: Array):
	for row in range(9):
		for col in range(9):
			if row == hinge_pos.x and col == hinge_pos.y:
				continue
			var cell_candidates = candidates[row][col]
			if cell_candidates.size() == 2 and shares_two_candidates(hinge_candidates, cell_candidates):
				# Check for pincer cells
				for other_row in range(9):
					for other_col in range(9):
						if (other_row == hinge_pos.x and other_col == hinge_pos.y) or (other_row == row and other_col == col):
							continue
						var other_cell_candidates = candidates[other_row][other_col]
						if other_cell_candidates.size() == 2 and shares_two_candidates(hinge_candidates, other_cell_candidates):
							if sees_each_other(Vector2(row, col), Vector2(other_row, other_col)):
								eliminate_xyz_wing_candidates(candidates, hinge_candidates, Vector2(row, col), Vector2(other_row, other_col))

func shares_two_candidates(candidates1: Array, candidates2: Array) -> bool:
	var common = 0
	for candidate in candidates1:
		if candidates2.has(candidate):
			common += 1
	return common == 2

func sees_each_other(cell1: Vector2, cell2: Vector2) -> bool:
	return cell1.x == cell2.x or cell1.y == cell2.y or (int(cell1.x / 3) == int(cell2.x / 3) and int(cell1.y / 3) == int(cell2.y / 3))

func eliminate_xyz_wing_candidates(candidates: Array, xyz_candidates: Array, pincer1: Vector2, pincer2: Vector2):
	var unique_candidate = -1
	for candidate in xyz_candidates:
		if not candidates[pincer1.x][pincer1.y].has(candidate) or not candidates[pincer2.x][pincer2.y].has(candidate):
			unique_candidate = candidate
			break
	if unique_candidate != -1:
		for row in range(9):
			for col in range(9):
				if (row != pincer1.x or col != pincer1.y) and (row != pincer2.x or col != pincer2.y):
					if sees_each_other(Vector2(row, col), pincer1) and sees_each_other(Vector2(row, col), pincer2):
						if unique_candidate in candidates[row][col]:
							candidates[row][col].erase(unique_candidate)
