#WWing.gd
extends Node

# Function to solve Sudoku using the W-Wing technique
func solve(candidates: Array) -> Array:
	#print("W-Wing")
	var check = candidates.duplicate(true)

	# Apply W-Wing technique
	w_wing(candidates)

	if check != candidates:
		print("W-Wing used")
	return candidates

# W-Wing technique
func w_wing(candidates: Array):
	for num1 in range(1, 10):
		for num2 in range(num1 + 1, 10):
			# Find pairs of num1 and num2
			var pairs = find_pairs(candidates, num1, num2)
			for pair1 in pairs:
				for pair2 in pairs:
					if pair1 == pair2:
						continue
					if sees_each_other(pair1, pair2) and forms_w_wing(candidates, pair1, pair2, num1, num2):
						eliminate_w_wing_candidates(candidates, pair1, pair2, num1, num2)

func find_pairs(candidates: Array, num1: int, num2: int) -> Array:
	var pairs = []
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() == 2 and candidates[row][col].has(num1) and candidates[row][col].has(num2):
				pairs.append(Vector2(row, col))
	return pairs

func sees_each_other(cell1: Vector2, cell2: Vector2) -> bool:
	return cell1.x == cell2.x or cell1.y == cell2.y or (int(cell1.x / 3) == int(cell2.x / 3) and int(cell1.y / 3) == int(cell2.y / 3))

func forms_w_wing(candidates: Array, pair1: Vector2, pair2: Vector2, num1: int, num2: int) -> bool:
	# Check if there are cells that see both pairs and contain only one of the numbers
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() == 1 and (candidates[row][col][0] == num1 or candidates[row][col][0] == num2):
				if sees_each_other(Vector2(row, col), pair1) and sees_each_other(Vector2(row, col), pair2):
					return true
	return false

func eliminate_w_wing_candidates(candidates: Array, pair1: Vector2, pair2: Vector2, num1: int, num2: int):
	for row in range(9):
		for col in range(9):
			if candidates[row][col].size() == 1 and (candidates[row][col][0] == num1 or candidates[row][col][0] == num2):
				if sees_each_other(Vector2(row, col), pair1) and sees_each_other(Vector2(row, col), pair2):
					# Eliminate the other number from cells seen by both wings
					var eliminate_num = (candidates[row][col][0] == num1) ? num2 : num1
					for i in range(9):
						if (i != col and candidates[row][i].has(eliminate_num)) or (i != row and candidates[i][col].has(eliminate_num)):
							candidates[i][col].erase(eliminate_num)
							candidates[row][i].erase(eliminate_num)
