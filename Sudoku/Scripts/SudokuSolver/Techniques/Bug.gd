#BUG.gd
extends Node

# Function to solve Sudoku using the BUG technique
func solve(candidates: Array) -> Array:
	#print("BUG Technique")
	var check = candidates.duplicate(true)

	# Apply BUG technique
	bug_technique(candidates)

	# if check != candidates:
	#     print("BUG Technique used")
	return candidates

# BUG technique
func bug_technique(candidates: Array):
	var three_candidate_cell = Vector2(-1, -1)
	var two_candidate_cells = 0

	# Check the state of the grid
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() == 2:
				two_candidate_cells += 1
			elif candidates[row][col].size() == 3:
				if three_candidate_cell == Vector2(-1, -1):
					three_candidate_cell = Vector2(row, col)
				else:
					# More than one cell with three candidates, not a BUG situation
					return

	# Apply BUG technique if the conditions are met
	if two_candidate_cells == 81 - 1 and three_candidate_cell != Vector2(-1, -1):
		apply_bug_elimination(candidates, three_candidate_cell)

func apply_bug_elimination(candidates: Array, three_candidate_cell: Vector2):
	var row = int(three_candidate_cell.x)
	var col = int(three_candidate_cell.y)
	var cell_candidates = candidates[row][col]

	# Logic to determine which candidate to eliminate
	# This part requires a careful check to see which of the three candidates can be safely eliminated
	# Usually, it's the candidate that, when removed, does not lead to a contradiction
