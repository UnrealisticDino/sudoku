#ForcingChains.gd
extends Node

# Function to solve Sudoku using the Forcing Chains technique
func solve(candidates: Array) -> Array:
	#print("Forcing Chains")
	var check = candidates.duplicate(true)

	# Apply Forcing Chains technique
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() > 1:
				forcing_chains(candidates, row, col)

	if check != candidates:
		print("Forcing Chains used")
	return candidates

# Forcing Chains technique for a single cell
func forcing_chains(candidates: Array, row: int, col: int):
	var cell_candidates = candidates[row][col]
	for candidate in cell_candidates:
		# Hypothetically assign a candidate and follow the implications
		var temp_candidates = candidates.duplicate(true)
		temp_candidates[row][col] = [candidate]
		var implications = follow_implications(temp_candidates, row, col)

		# Check if a particular cell ends up with the same value regardless of the choice
		for imp_row in range(9):
			for imp_col in range(9):
				if is_conclusive(implications, imp_row, imp_col):
					candidates[imp_row][imp_col] = implications[imp_row][imp_col]

func follow_implications(temp_candidates: Array, row: int, col: int) -> Array:
	# Implement the logic to follow the implications of assigning a candidate
	# This function will recursively apply Sudoku solving logic based on the temporary assignment
	# and return the state of the grid after following all implications
	return temp_candidates

func is_conclusive(implications: Array, row: int, col: int) -> bool:
	# Determine if the implications lead to a conclusive result for the cell at (row, col)
	# A conclusive result means that the cell ends up with the same candidate regardless of the initial assumptions
	return implications[row][col].size() == 1
