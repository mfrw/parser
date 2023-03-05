#!/usr/bin/python3
from typing import Generator, List, Optional, Tuple, Type, Union, cast 

from specfile import Specfile
import pathlib
import re
import os
import argparse

from enum import Enum
from functools import cmp_to_key
from os.path import dirname


# Define this globally as a bad HACK

class SParser:
    __macros = [("with_check", "0")]
    SOURCE_VALUE_REGEX = re.compile(r"[^\s#]+")

    def __init__(self, raw_spec: str):
        self.spec_path = raw_spec
        self.spec = Specfile(raw_spec, force_parse=True, macros=self.__macros)
        self.expanded_location = None


    def source0_url(self) -> str:
        with self.spec.sources() as sources:
            if len(sources) > 0:
                self.expanded_location = sources[0].expanded_location
        if self.expanded_location is not None:
            return self.SOURCE_VALUE_REGEX.search(self.expanded_location).group()

    def source0_name(self) -> str:
        if self.expanded_location is None:
            with self.spec.sources() as sources:
                if len(sources) > 0:
                    self.expanded_location = sources[0].expanded_location
                else:
                    return None
        loc = self.expanded_location
        sp = loc.split("/")
        if len(sp) > 0:
            return sp[-1]

    def spec_name(self) -> str:
        return self.spec.expanded_name

    def spec_release(self) -> str:
        return self.spec.expanded_release

    def spec_version(self) -> str:
        return self.spec.expanded_version

    def dir_name(self) -> str:
        return os.path.dirname(self.spec_path)


# Get a name,ver,rel,url
def get_name_ver_url(raw_spec: str) -> Tuple[str, str, str, str]:
    spec = Specfile(raw_spec, force_parse=True, macros=macros)


    expanded_location = ''
    with spec.sources() as sources:
        if len(sources) > 0:
            expanded_location = sources[0].expanded_location
    return (spec.expanded_name, spec.expanded_version, spec.expanded_release, expanded_location)

def process_spec(raw_spec: str):
    sp = SParser(raw_spec)
    s_name = sp.spec_name()
    s_ver = sp.spec_version()
    s_rel = sp.spec_release()
    s_url = sp.source0_url()
    s_dir = sp.dir_name()
    s_src_name = sp.source0_name()
    srpm_name = '{}-{}-{}.cm2.src.rpm'.format(s_name, s_ver, s_rel)

    print("")
    print("Spec Name:", s_name)
    print("Spec URL :", s_url)
    print("Spec Rel :", s_rel)
    print("Spec Dir :", s_dir)
    print("Src Name :", s_src_name)
    print("SRPM Name:", srpm_name)
    print("TODEL    :", os.path.join(s_dir, s_src_name))
    print("WGET     :", 'wget -O {} {}'.format(os.path.join(s_dir, s_src_name), s_url))
    print("")

def main():
    parser = argparse.ArgumentParser(description="Get Details About Spec(s)")
    parser.add_argument('spec', help='Path to specfile')
    args = parser.parse_args()
    #for raw_spec in pathlib.Path('/home/mfrw/mariner-org/CBL-Mariner/SPECS-EXTENDED').glob('**/*.spec'):
    #    process_spec(raw_spec)

    process_spec(args.spec)


if __name__ == '__main__':
    main()
