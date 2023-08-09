import pygame
import random
import logging
import ast
from copy import deepcopy

# Initialize Pygame
pygame.init()

# Set up the display
WIDTH, HEIGHT = 540, 540
WINDOW = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Sudoku Maker")

# Colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GRAY = (200, 200, 200)
BLUE = (0, 0, 255)

# Fonts
FONT_SMALL = pygame.font.SysFont(None, 30)
FONT_LARGE = pygame.font.SysFont(None, 60)

# Load completed puzzles
with open("sudoku_logs.txt", "r") as f:
    content = f.read()
    completed_puzzles = [ast.literal_eval(puzzle_str) for puzzle_str in content.split('\n') if puzzle_str]

def draw_puzzle(puzzle):
    WINDOW.fill(WHITE)
    for i in range(9):
        for j in range(9):
            cell_value = puzzle[i][j]
            if cell_value != 0:
                text = FONT_LARGE.render(str(cell_value), True, BLACK)
                text_rect = text.get_rect(center=(j * 60 + 30, i * 60 + 30))
                WINDOW.blit(text, text_rect)
    for i in range(10):
        if i % 3 == 0:
            pygame.draw.line(WINDOW, BLACK, (0, i * 60), (540, i * 60), 3)
            pygame.draw.line(WINDOW, BLACK, (i * 60, 0), (i * 60, 540), 3)
        else:
            pygame.draw.line(WINDOW, GRAY, (0, i * 60), (540, i * 60), 1)
            pygame.draw.line(WINDOW, GRAY, (i * 60, 0), (i * 60, 540), 1)
    pygame.display.update()

    
def scan_solve(puzzle):
    progress = True
    while progress:
        progress = False

        # Check each cell
        for row in range(9):
            for col in range(9):
                if puzzle[row][col] != 0:
                    continue  # Skip filled cells

                possibilities = get_possible_numbers(puzzle, row, col)

                # Single possibility
                if len(possibilities) == 1:
                    puzzle[row][col] = possibilities.pop()
                    progress = True
                    continue

                # Unique candidate in row
                row_possibilities = [get_possible_numbers(puzzle, row, c) for c in range(9) if puzzle[row][c] == 0]
                unique_candidates = [p for p in possibilities if not any(p in rp for rp in row_possibilities if rp != possibilities)]
                if len(unique_candidates) == 1:
                    puzzle[row][col] = unique_candidates[0]
                    progress = True
                    continue

                # Unique candidate in column
                col_possibilities = [get_possible_numbers(puzzle, r, col) for r in range(9) if puzzle[r][col] == 0]
                unique_candidates = [p for p in possibilities if not any(p in cp for cp in col_possibilities if cp != possibilities)]
                if len(unique_candidates) == 1:
                    puzzle[row][col] = unique_candidates[0]
                    progress = True
                    continue

                # Unique candidate in 3x3 grid
                grid_possibilities = [get_possible_numbers(puzzle, r, c) for r in range(row // 3 * 3, row // 3 * 3 + 3) for c in range(col // 3 * 3, col // 3 * 3 + 3) if puzzle[r][c] == 0]
                unique_candidates = [p for p in possibilities if not any(p in gp for gp in grid_possibilities if gp != possibilities)]
                if len(unique_candidates) == 1:
                    puzzle[row][col] = unique_candidates[0]
                    progress = True
                    continue

    # If we've filled all the cells, the puzzle is solved
    return all(puzzle[row][col] != 0 for row in range(9) for col in range(9))

def get_possible_numbers(puzzle, row, col):
    # Get the set of numbers that are not present in the row, column, or 3x3 grid
    row_vals = set(puzzle[row])
    col_vals = set(puzzle[r][col] for r in range(9))
    grid_vals = set(puzzle[r][c] for r in range(row // 3 * 3, row // 3 * 3 + 3) for c in range(col // 3 * 3, col // 3 * 3 + 3))
    all_vals = set(range(1, 10))

    # Check for King's Move
    king_vals = set()
    for dr in [-1, 0, 1]:
        for dc in [-1, 0, 1]:
            if 0 <= row + dr < 9 and 0 <= col + dc < 9:
                king_vals.add(puzzle[row + dr][col + dc])

    # Check for Knight's Move
    knight_vals = set()
    for dr, dc in [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]:
        if 0 <= row + dr < 9 and 0 <= col + dc < 9:
            knight_vals.add(puzzle[row + dr][col + dc])

    # Check for Adjacent Digits
    adjacent_vals = set()
    for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        if 0 <= row + dr < 9 and 0 <= col + dc < 9:
            cell_val = puzzle[row + dr][col + dc]
            if cell_val > 1:
                adjacent_vals.add(cell_val - 1)
            if cell_val < 9:
                adjacent_vals.add(cell_val + 1)

    return all_vals - (row_vals | col_vals | grid_vals | king_vals | knight_vals | adjacent_vals)


def generate_puzzle(completed_puzzle):
    puzzle = deepcopy(completed_puzzle)

    # Flatten the puzzle to a list of cell coordinates
    cells = [(row, col) for row in range(9) for col in range(9)]
    random.shuffle(cells)

    # Initialize variable to keep track of whether a digit was removed in the last iteration
    digit_removed = True

    while digit_removed:  # Continue until no more digits can be removed
        digit_removed = False  # Reset the flag at the start of each loop

        for row, col in cells:
            # Skip if the cell is already empty
            if puzzle[row][col] == 0:
                continue

            # Temporarily remove a number
            removed_num = puzzle[row][col]
            puzzle[row][col] = 0

            # Check if the puzzle can still be solved using human techniques
            if scan_solve(deepcopy(puzzle)):
                # If yes, a number was removed, update the flag and break the loop
                digit_removed = True
                break
            else:
                # If not, put the number back
                puzzle[row][col] = removed_num

        # Re-shuffle the cells for the next iteration to try removing digits in a different order
        random.shuffle(cells)

    return puzzle


def save_puzzle(puzzle, puzzle_number):
    with open(f"puzzle_{puzzle_number}.txt", "w") as f:
        for row in puzzle:
            f.write(" ".join(str(num) for num in row))
            f.write("\n")

def main():
    clock = pygame.time.Clock()
    puzzle_number = 1
    for completed_puzzle in completed_puzzles:
        # Generate a new puzzle
        puzzle = generate_puzzle(completed_puzzle)

        # Save the generated puzzle as a text file
        save_puzzle(puzzle, puzzle_number)
        puzzle_number += 1

        # Draw the puzzle and update the display
        draw_puzzle(puzzle)
        pygame.display.update()

        # Delay for a bit so the user can see the puzzle
        pygame.time.delay(1000)  # delay for 1000 milliseconds = 1 second

    pygame.quit()


if __name__ == '__main__':
    main()