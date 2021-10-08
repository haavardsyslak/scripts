#!/usr/bin/python3
import rmrl
import shutil
import os
import hashlib

# TODO: Make compare zip files and only cenvert files that have changed since last download
# https://stackoverflow.com/questions/31027268/pythonfunction-that-compares-two-zip-files-one-located-in-ftp-dir-the-other

def works():
    output_base_dir = "/home/syslak/uisfiles/"
    for subdir, dirs, files in os.walk("/tmp/remarkable"):
        for file in files:
            if file.endswith(".zip"):
                if file == "Quick sheets.zip":
                    continue
                file_str = os.path.join(subdir, file)
                tmp = file_str.split("/")
                outfile_str = f'{output_base_dir}/{"/".join(tmp[2:])}'
                outfile_str.replace(".zip", ".pdf")
                outfile_str = outfile_str.split(".")[0] + ".pdf"
                print("converting file: ", outfile_str)
                out_file = rmrl.render(file_str)
                out_dir = f'{"/".join(outfile_str.split("/")[0:-1])}'
                if not os.path.isdir(out_dir):
                    os.makedirs(out_dir)
                with open(outfile_str, "wb") as f:
                    shutil.copyfileobj(out_file, f)

last_files = list()
for subdir, dirs, file in os.walk("/home/syslak/.cache/remarkable"):
    file_str = os.path.join(subdir, file)
    last_files.append(file_str)

current_files = list()
for subdir, dirs, file in os.walk("/tmp/remarkable"):
    file_str = os.path.join(subdir, file)
    current_files.append(file_str)

current_files.sort()
last_files.sort()

for i in range(len(current_files)):
    if current_files[i] == last_files[i]:
        if compare_file():
            convert_to_pdf(current_files[i])
        else:
            print("Skipping.. ", current_files[i])

    else:
        convert_to_pdf(current_file[i])
    

def convert_to_pdf():
    pass

def compare_file(file1, file2):
    pass

works()
