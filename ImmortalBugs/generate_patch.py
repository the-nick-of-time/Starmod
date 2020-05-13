#!/usr/bin/env python3
from textwrap import dedent
from pathlib import Path
from typing import Container


def locate_bugs(assets_root: Path) -> Container[Path]:
    bugs_dir = assets_root / 'monsters/bugs'
    return [bug.relative_to(assets_root) for bug in bugs_dir.glob('**/*.monstertype')]


def write_patch(src_root: Path, bug: Path) -> None:
    patch_file = Path(str(src_root / bug) + '.patch')
    patch_file.parent.mkdir(parents=True, exist_ok=True)
    patch = dedent("""
                   [
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
                   ]""")
    patch_file.write_text(patch)


def main():
    here = Path(__file__).parent.absolute()
    unpacked_root = here.parent / 'unpacked'
    src_root = here / 'src'
    critters = locate_bugs(unpacked_root)
    for critter in critters:
        write_patch(src_root, critter)


if __name__ == '__main__':
    main()
