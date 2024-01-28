#Skyscraper.gd
extends Node

# Function to solve Sudoku using the Skyscraper technique
func solve(candidates: Array) -> Array:
	#print("Skyscraper")
	var check = candidates.duplicate(true)

	# Apply Skyscraper technique for each number
	for num in range(1, 10):
		skyscraper(candidates, num)

	if check != candidates:
		print("Skyscraper used")
	return candidates

# Skyscraper technique for a single number
func skyscraper(candidates: Array, num: int):
	# Check for Skyscraper in rows
	for row1 in range(8):
		for row2 in range(row1 + 1, 9):
			check_skyscraper(candidates, num, row1, row2, true) # true for rows
	# Check for Skyscraper in columns
	for col1 in range(8):
		for col2 in range(col1 + 1, 9):
			check_skyscraper(candidates, num, col1, col2, false) # false for columns

func check_skyscraper(candidates: Array, num: int, line1: int, line2: int, isRow: bool):
	var positions1 = find_num_positions(candidates, num, line1, isRow)
	var positions2 = find_num_positions(candidates, num, line2, isRow)
	
	if positions1.size() == 2 and positions2.size() == 2:
		# Check if they form a rectangle
		if (positions1[0].x == positions2[0].x or positions1[0].x == positions2[1].x) and (positions1[1].x == positions2[0].x or positions1[1].x == positions2[1].x):
			# Skyscraper found, eliminate candidates
			eliminate_skyscraper_candidates(candidates, num, positions1, positions2)

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

func eliminate_skyscraper_candidates(candidates: Array, num: int, positions1: Array, positions2: Array):
	# Eliminate candidates seen by both ends of the skyscraper
	for i in range(9):
		if positions1[0].y != i and positions1[1].y != i and positions2[0].y != i and positions2[1].y != i:
			if num in candidates[positions1[0].x][i]:
				candidates[positions1[0].x][i].erase(num)
			if num in candidates[positions2[0].x][i]:
				candidates[positions2[0].x][i].erase(num)
		if positions1[0].x != i and positions1[1].x != i and positions2[0].x != i and positions2[1].x != i:
			if num in candidates[i][positions1[0].y]:
				candidates[i][positions1[0].y].erase(num)
			if num in candidates[i][positions2[0].y]:
				candidates[i][positions2[0].y].erase(num)
