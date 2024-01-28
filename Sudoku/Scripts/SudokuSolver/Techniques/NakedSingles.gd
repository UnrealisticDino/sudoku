#NakedSingles.gd
extends Node

# Function to solve naked singles in a Sudoku grid
func solve(candidates: Array) -> Array:
	#print("NakedSingles")
	#var check = candidates.duplicate(true)
	var updated = false

	# Iterate over each cell in the grid
	for row in range(9):
		for col in range(9):
			# Skip cells with a single candidate (already a naked single)
			if typeof(candidates[row][col]) == TYPE_ARRAY and candidates[row][col].size() == 1:
				continue

			# Count the number of possibilities for cells with more than one candidate
			if typeof(candidates[row][col]) == TYPE_ARRAY:
				var possibilities_count = 0
				var last_num = 0
				for num in range(1, 10):
					if num in candidates[row][col]:
						possibilities_count += 1
						last_num = num

				# If there's only one possibility, it's a naked single
				if possibilities_count == 1:
					candidates[row][col] = [last_num]  # Update to contain only the naked single
					updated = true

#	if check != candidates:
#		print("NakedSingles used")
	return candidates
