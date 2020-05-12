#!/usr/bin/env python3
import json
import os
from pathlib import Path
from typing import Container


patch = """[
    {
        "op" : "replace",
        "path" : "/baseParameters/statusSettings/stats/maxHealth",
        "value" : { "baseValue" : 50000 }
    },
	{
        "op" : "replace",
        "path" : "/baseParameters/statusSettings/stats/healthRegen",
        "value" : { "baseValue" : 50000 }
    }
]"""


def locate_critters(fu_root: Path) -> Container[Path]:
    critters_dir = fu_root / 'monsters/critter'
    return [critter.relative_to(fu_root) for critter in critters_dir.glob('**/*.monstertype')]


def write_patch(src_root: Path, critter: Path) -> None:
    patch_file = Path(str(src_root / critter) + '.patch')
    patch_file.parent.mkdir(parents=True, exist_ok=True)
    patch_file.write_text(patch)


def main():
    here = Path(__file__).parent.absolute()
    critters = locate_critters(here.parent / 'dependencies/FrackinUniverse')
    for critter in critters:
        write_patch(here / 'src', critter)


if __name__ == '__main__':
    main()
