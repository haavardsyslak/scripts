#!/usr/bin/python3
import rmrl
import shutil
import os
output_base_dir = "/home/syslak/uisfiles/remarkable"
for subdir, dirs, files in os.walk("/tmp/remarkable"):
    for file in files:
        if file.endswith(".zip"):
            if file == "Quick sheets.zip":
                continue
            file_str = os.path.join(subdir, file)
            tmp = file_str.split("/")
            outfile_str = f'{output_base_dir}/{"/".join(tmp[1:])}'
            outfile_str.replace(".zip", ".pdf")
            outfile_str = outfile_str.split(".")[0] + ".pdf"
            print("converting file: ", outfile_str)
            out_file = rmrl.render(file_str)
            out_dir = f'{"/".join(outfile_str.split("/")[0:-1])}'
            if not os.path.isdir(out_dir):
                os.makedirs(out_dir)
            with open(outfile_str, "wb") as f:
                shutil.copyfileobj(out_file, f)
