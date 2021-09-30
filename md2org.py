#!/Usr/bin/env python3

import os
import re
from pathlib import Path


home = str(Path.home())

def read_files():
    files = list()
    for file in os.listdir("."):
        if file.endswith(".md"):
            files.append(file)

    return files

def regex_meister(fil):
    split = fil.split(".")
    tmp =  str(split[0]) if  len(split) > 1 else fil
    files = list()

    fil = home + "/uisfiles/notes/" + tmp + ".md"
    print(f"working on file: {fil}")
    outfile = home + outdir + tmp + ".org"
    prefix = home + "/uisfiles/orgwiki/" + "/".join(tmp.split("/")[0:-1]) + "/" if tmp != "index" else home + "/uisfiles/orgwiki/"
    tmp = tmp.split("/")
    img_prefix = "~/uisfiles/notes/" if len(tmp) == 1 else "~/uisfiles/notes/html/" + "/".join(tmp[0:-1]) + "/"

    linkregex = r"(\[[^]]+\])\(([^.)]+)(\.md)?\)"
    external_linkregex = r"(\[[a-zA-z0-9]+)(\(.+\))"
    img_regex = r"(!\[[^]]*\])\(([^.)]+)(.+)"
    # (?<!!)(\[[^]]+\])\(([^.)]+)(\.md)?\) file regex that does not match ![](img)

    with open(fil, "r") as f:
        lines = f.readlines()
        f.close()

    # fix headers
    new_str = list()
    while lines:
        l = lines.pop(0)

        if l[0:3] == "```":
            language =  l[3:].strip()

            l = lines.pop(0)
            code = l
            while l.strip() != "```":
                code = code + l
                l = lines.pop(0)

            if language == "":
                new_str.append(code)

            else:
                new_str.append(f"#+BEGIN_SRC {language}\n{code}#+END_SRC\n")

            continue

        if l.startswith("#"):
            tmp = l.split()
            tmp[0] = tmp[0].replace("#", "*")
            l = " ".join(tmp)
            if not "\n" in l:
                l = l + "\n"

        # Img regex
        match = re.search(img_regex, l)
        if match != None:
            split = l.split(str(match.group(0)))
            description = match.group(1)[2:-1]

            filename = img_prefix + match.group(2) + match.group(3).strip().replace(")", "")

            if description.strip() == "":
                l = f"{split[0]}[[{filename}]]{split[1]}\n"

            else:
                l = f"{split[0]}[[{filename}][{description}]]{split[1]}\n"

        # Internal link
        match = re.search(linkregex, l)
        if match != None:
            # l = re.sub(linkregex, "", l)
            split = l.split(str(match.group(0)))
            description = match.group(1)[1:-1]
            # filename = "~/uisfiles/orgwiki/"  + match.group(2) + ".org"
            filename = prefix + match.group(2) + ".org"
            files.append(match.group(2))

            l = f"{split[0]}[[{filename}][{description}]]{split[1]}\n"

        # External link
        match = re.search(external_linkregex, l)
        if match != None:
            split = l.split(str(match.group(0)))

            description = match.group(1)[1:-1]
            filename = match.group(2)[1:-1]

            l =  f"{split[0]}[[{filename}][{description}]]{split[1]}\n"


        new_str.append(l)



    content = ""
    for i in new_str:
        content = content + str(i)

    os.makedirs(os.path.dirname(outfile), exist_ok=True)

    print("Outfile:", outfile)
    input()
    with open(outfile, "w") as f:
        f.write(content)
        f.close()

    return(files)


def main():
    global outdir
    outdir = "/" + input("Org-wiki dir (relative to home folder)").strip()

    if outdir == "/":
        outdir = "/orgwiki/"

    elif outdir[-1] != "/":
        outdir = outdir + "/"


    index_files = regex_meister("index.md")
    for i in index_files:
        files = regex_meister(i)

        for j in files:
            if j not in files:
                index_files.append(j)

if __name__ == "__main__":
    main()
