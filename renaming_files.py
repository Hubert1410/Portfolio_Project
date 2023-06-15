'''''''''''''''''''''''''''''''''
Coping & Renaming files specified in Excel file.
This Python code was made to automate our weekly process in my job.
Done by me with the help from colleague.

Skills used: Pandas, DataFrame, File and Path Operations, Loops and Conditional Statements

'''''''''''''''''''''''''''''''''

import pandas as pd
import os
import shutil

# Ścieżka do pliku Excela
excel_path = "C:/Users/Desktop/Python/Data.xlsx"

# Wczytanie pliku Excela
df = pd.read_excel(excel_path)

# Iteracja przez wiersze DataFrame
for index, row in df.iterrows():
    filename = str(row['A'])  # Wartość komórki A w danym wierszu
    new_filename = row['B']  # Wartość komórki B w danym wierszu

    # Sprawdzenie, czy istnieje plik o nazwie zgodnej z wartością komórki A
    if os.path.isfile(filename):
        # Tworzenie ścieżki do folderu "XCOPIED_STORES" na tej samej ścieżce
        folder_path = os.path.join(os.path.dirname(filename), "XCOPIED_STORES")

        # Sprawdzenie, czy folder "XCOPIED_STORES" nie istnieje
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)

        # Tworzenie ścieżki docelowej dla skopiowanego pliku
        new_filepath = os.path.join(folder_path, os.path.basename(filename))

        # Kopiowanie pliku do folderu "XCOPIED_STORES"
        shutil.copy2(filename, new_filepath)

        # Zmiana nazwy skopiowanego pliku zgodnie z wartością komórki B
        new_filepath_renamed = os.path.join(folder_path, new_filename)
        os.rename(new_filepath, new_filepath_renamed)
        print(f"Skopiowano i zmieniono nazwę pliku {filename} na {new_filepath_renamed}")
    else:
        print(f"Plik {filename} nie istnieje")

print("Zakończono")
