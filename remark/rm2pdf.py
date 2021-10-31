#!/usr/bin/python3

import shutil
import os
import hashlib
import rmrl

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


def main():
    last_files = list()
    for subdir, _, files in os.walk("/home/syslak/.cache/remarkable"):
        for f in files:
            file_str = os.path.join(subdir, f)
            last_files.append(file_str)

    current_files = list()
    for subdir, _, files in os.walk("/tmp/remarkable"):
        for f in files:
            file_str = os.path.join(subdir, f)
            current_files.append(file_str)


    for i in current_files:
        exists = False
        f_name = i.split("tmp/")[1]
        for j in last_files:
            tmp = j.split(".cache/")[1]
            if f_name == tmp:
                if not compare_files(i, j):
                    exists = True
                    convert_to_pdf(i)
                    last_files.remove(j)
                else:
                    print(f"Skipping {i}")
                    exists = True
                    break
        if not exists:
            convert_to_pdf(i)



def convert_to_pdf(f):
    file_name = f.split(".")[0].split("/")[-1]
    out_dir = f"/home/syslak/uisfiles/" + "/".join(f.split("tmp/")[1].split("/")[0:-1])
    out_file_str = out_dir + "/" + file_name + ".pdf"
    print(f"Converting file: {out_file_str}")
    out_file = rmrl.render(f)


    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)
    with open(out_file_str, "wb") as f:
        shutil.copyfileobj(out_file, f)


def compare_files(file1, file2):
    with open(file1, "rb") as f_1:
        f1_hash = hashlib.sha256(f_1.read()).digest()
    with open(file2, "rb") as f_2:
        f2_hash = hashlib.sha256(f_2.read()).digest()

    return f1_hash == f2_hash


main()
