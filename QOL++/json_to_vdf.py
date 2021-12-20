import sys
from pathlib import Path
import json

template = '''"workshopitem"
{{
"appid" "211820"
"publishedfileid" "{id}"
"contentfolder" "{content}"
"previewfile" "{icon}"
"visibility" "0"
"title" "{name}"
"description" "{description}"
"changenote" "{changes}"
}}'''

def convert():
    data = json.load(sys.stdin)
    print(template.format(
        id = data["steamContentId"],
        content = str(Path(sys.argv[1]).absolute()),
        icon = str(Path(sys.argv[2]).absolute()),
        name = data["friendlyName"],
        description = data["description"],
        changes = ""
    ))

if __name__ == "__main__":
    convert()
