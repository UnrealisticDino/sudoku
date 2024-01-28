#EmptyRectangle.gd
extends Node

# Function to solve Sudoku using the Empty Rectangle technique
func solve(candidates: Array) -> Array:
	#print("Empty Rectangle")
	var check = candidates.duplicate(true)

	# Apply Empty Rectangle technique for each number
	for num in range(1, 10):
		empty_rectangle(candidates, num)

	if check != candidates:
		print("Empty Rectangle used")
	return candidates

# Empty Rectangle technique for a single number
func empty_rectangle(candidates: Array, num: int):
	# Check in each 3x3 box
	for box_row in range(3):
		for box_col in range(3):
			var base_row = box_row * 3
			var base_col = box_col * 3
			check_empty_rectangle(candidates, num, base_row, base_col)

func check_empty_rectangle(candidates: Array, num: int, base_row: int, base_col: int):
	# Check all possible rectangles in the box
	for row_offset in range(3):
		for col_offset in range(3):
			var empty_rect_row = base_row + row_offset
			var empty_rect_col = base_col + col_offset

			# Check if the corner is empty
			if candidates[empty_rect_row][empty_rect_col].find(num) == -1:
				# Check for alignments and eliminate candidates
				for i in range(3):
					if i != row_offset and num in candidates[base_row + i][empty_rect_col]:
						eliminate_candidates_in_line(candidates, num, base_row + i, true)
					if i != col_offset and num in candidates[empty_rect_row][base_col + i]:
						eliminate_candidates_in_line(candidates, num, base_col + i, false)

func eliminate_candidates_in_line(candidates: Array, num: int, line: int, isRow: bool):
	for i in range(9):
		if isRow:
			if num in candidates[line][i]:
				candidates[line][i].erase(num)
		else:
			if num in candidates[i][line]:
				candidates[i][line].erase(num)
