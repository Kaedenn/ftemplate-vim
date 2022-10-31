#!/usr/bin/env python3

"""

"""

import argparse
import logging
import os
import sys

logging.basicConfig(format="%(module)s:%(lineno)s: %(levelname)s: %(message)s",
                    level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
  ap = argparse.ArgumentParser()
  ap.add_argument("-v", "--verbose", action="store_true", help="verbose output")
  args = ap.parse_args()
  if args.verbose:
    logger.setLevel(logging.DEBUG)

if __name__ == "__main__":
  main()

# vim: set ts=2 sts=2 sw=2:
