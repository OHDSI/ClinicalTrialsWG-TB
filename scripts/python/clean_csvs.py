import csv
import sys
import os
import json

# Load the file_dict JSON object from the first argument
file_dict = json.loads(sys.argv[1])

# Loop through each file in file_dict
for file_name, file_path in file_dict.items():
    # Read the CSV file
    with open(file_path, 'r') as csv_file:
        reader = csv.reader(csv_file)
        rows = list(reader)

    # Check if the first column header is unnamed or empty
    if rows and (rows[0][0].strip() == "" or len(rows[0][0]) == 0):
        rows[0][0] = "id"  # Rename the first column to "id"

        # Write the updated CSV back to the file
        with open(file_path, 'w', newline='') as csv_file:
            writer = csv.writer(csv_file)
            writer.writerows(rows)

        print(f"Updated header for file: {file_path}")
    else:
        print(f"No changes needed for file: {file_path}")