#!/usr/bin/env python3
from pathlib import Path
import xml.etree.ElementTree as ET

project = Path("src/ssc.lpi")
tree = ET.parse(project)
root = tree.getroot()

required = root.find("./ProjectOptions/RequiredPackages")
if required is None:
    raise SystemExit("RequiredPackages not found")

for item in list(required):
    pkg = item.find("PackageName")
    if pkg is not None and pkg.attrib.get("Value") in {"openai_input", "openai_core"}:
        required.remove(item)

search = root.find("./CompilerOptions/SearchPaths")
if search is None:
    raise SystemExit("CompilerOptions/SearchPaths not found")

for child in list(search):
    if child.tag == "OtherUnitFiles":
        search.remove(child)

other = ET.Element(
    "OtherUnitFiles",
    {
        "Value": "../../CHATGPT/pacote;../../CHATGPT/pacote/AI;../../CHATGPT/pacote/AI Input/AISerial"
    },
)
search.insert(0, other)

try:
    ET.indent(tree, space="  ")
except AttributeError:
    pass

tree.write(project, encoding="UTF-8", xml_declaration=True)
print("Prepared src/ssc.lpi for CI source-based CHATGPT build")
