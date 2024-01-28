#UniqueRectangles.gd
extends Node

# Function to solve Sudoku using the Unique Rectangles technique
func solve(candidates: Array) -> Array:
	#print("Unique Rectangles")
	var check = candidates.duplicate(true)

	# Apply Unique Rectangles technique for each pair of numbers
	for num1 in range(1, 10):
		for num2 in range(num1 + 1, 10):
			unique_rectangles(candidates, num1, num2)

	if check != candidates:
		print("Unique Rectangles used")
	return candidates

# Unique Rectangles technique for a pair of numbers
func unique_rectangles(candidates: Array, num1: int, num2: int):
	# Check every combination of rows and columns
	for row1 in range(8):
		for row2 in range(row1 + 1, 9):
			for col1 in range(8):
				for col2 in range(col1 + 1, 9):
					check_unique_rectangle(candidates, num1, num2, row1, row2, col1, col2)

func check_unique_rectangle(candidates: Array, num1: int, num2: int, row1: int, row2: int, col1: int, col2: int):
	var cells = [
		Vector2(row1, col1),
		Vector2(row1, col2),
		Vector2(row2, col1),
		Vector2(row2, col2)
	]

	var num_candidates = 0
	for cell in cells:
		if num1 in candidates[cell.x][cell.y] and num2 in candidates[cell.x][cell.y]:
			num_candidates += 1

	if num_candidates >= 3:
		# Potential Unique Rectangle pattern found
		# Check and eliminate extra candidates
		for cell in cells:
			var cell_candidates = candidates[cell.x][cell.y]
			if cell_candidates.size() == 2 and cell_candidates.has(num1) and cell_candidates.has(num2):
				continue
			for num in cell_candidates.duplicate():
				if num != num1 and num != num2:
					candidates[cell.x][cell.y].erase(num)
