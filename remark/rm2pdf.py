#!/usr/bin/python3

import shutil
import os
import zipfile
import rmrl

# TODO: Make compare zip files and only cenvert files that have changed since last download
# https://stackoverflow.com/questions/31027268/pythonfunction-that-compares-two-zip-files-one-located-in-ftp-dir-the-other



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
    out_dir = "/home/syslak/uisfiles/" + "/".join(f.split("tmp/")[1].split("/")[0:-1])
    out_file_str = out_dir + "/" + file_name + ".pdf"
    print(f"Converting file: {out_file_str}")
    out_file = rmrl.render(f)

    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)
    with open(out_file_str, "wb") as f:
        shutil.copyfileobj(out_file, f)


def compare_files(file1, file2):
    zip1 = zipfile.ZipFile(file1).infolist()
    zip2 = zipfile.ZipFile(file2).infolist()
    if len(zip1) != len(zip2):
        return False
    for j, k in zip(zip1, zip2):
        if j.CRC != k.CRC:
            return False
    return True


main()
