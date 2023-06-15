'''''''''''''''''''''''''''''''''
Coping & Renaming files specified in Excel file.
This Python code was made to automate our weekly process in my job.
Done by me with the help from colleague.

Skills used: Pandas, DataFrame, File and Path Operations, Loops and Conditional Statements

'''''''''''''''''''''''''''''''''

import pandas as pd
import os
import shutil

# Path to the Excel file
excel_path = "C:/Users/Desktop/Python/Data.xlsx"

# Read the Excel file
df = pd.read_excel(excel_path)

# Iterate through the DataFrame rows
for index, row in df.iterrows():
    filename = str(row['A'])
    new_filename = row['B']

    # Check if a file with the name from cell A exists
    if os.path.isfile(filename):
        # Create a path for the "XCOPIED_STORES" folder in the same directory
        folder_path = os.path.join(os.path.dirname(filename), "XCOPIED_STORES")

        # Check if the "XCOPIED_STORES" folder doesn't exist
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)

        # Create the destination path for the copied file
        new_filepath = os.path.join(folder_path, os.path.basename(filename))

        # Copy the file to the "XCOPIED_STORES" folder
        shutil.copy2(filename, new_filepath)

        # Rename the copied file according to the value in cell B
        new_filepath_renamed = os.path.join(folder_path, new_filename)
        os.rename(new_filepath, new_filepath_renamed)
        print(f"Copied and renamed file {filename} to {new_filepath_renamed}")
    else:
        print(f"File {filename} does not exist")

print("Finished")
