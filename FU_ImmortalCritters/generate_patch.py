#!/usr/bin/env python3
import json
import itertools
from textwrap import dedent
from pathlib import Path
from typing import Container


def locate_critters(fu_root: Path, relative_path: str) -> Container[Path]:
    critters_dir = fu_root / relative_path
    return [critter.relative_to(fu_root) for critter in critters_dir.glob('**/*.monstertype')]


def write_patch(src_root: Path, critter: Path) -> None:
    patch_file = Path(str(src_root / critter) + '.patch')
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


def update_metadata(fu_root: Path, src_root: Path):
    fu = json.loads((fu_root / '.metadata').read_text())
    src = json.loads("""
                     {
                        "author" : "the-nick-of-time",
                        "description" : "Extends the effects of HaxoXD's Immortal Critters mod to the critters added by Frackin Universe",
                        "includes" : [],
                        "friendlyName" : "FU Immortal Critters",
                        "name" : "FUcritters",
                        "requires" : ["immortalcritters", "FrackinUniverse"],
                        "version" : "1.0"
                     }""")
    src['version'] = fu['version']
    (src_root / '.metadata').write_text(json.dumps(src, indent=2))


def main():
    here = Path(__file__).parent.absolute()
    fu_root = here.parent / 'dependencies/FrackinUniverse'
    src_root = here / 'src'
    critters = locate_critters(fu_root, 'monsters/critter')
    bees = locate_critters(fu_root, 'monsters/bees')
    for critter in itertools.chain(critters, bees):
        write_patch(src_root, critter)
    update_metadata(fu_root, src_root)


if __name__ == '__main__':
    main()
