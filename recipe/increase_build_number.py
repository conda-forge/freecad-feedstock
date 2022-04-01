#!/usr/bin/env python

import re

with open("meta.yaml", "r") as f:
    text = f.read()

build_number_old = int(re.search(r"(?<={% set build_number = )\d+", text)[0])
build_number_new = build_number_old + 1
print(f"set build_number from build_number {build_number_old} to {build_number_new}")
text = re.sub(r"(?<={% set build_number = )\d+", str(build_number_new), text)
with open("meta.yaml", "w") as f:
    f.write(text)
