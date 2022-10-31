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
  ag = ap.add_argument_group("logging")
  mg = ag.add_mutually_exclusive_group()
  mg.add_argument("-v", "--verbose", action="store_true",
      help="enable verbose diagnostics")
  mg.add_argument("-w", "--warnings", action="store_true",
      help="hide info diagnostics")
  mg.add_argument("-e", "--errors", action="store_true",
      help="hide info and warning diagnostics")
  args = ap.parse_args()
  if args.verbose:
    logger.setLevel(logging.DEBUG)

if __name__ == "__main__":
  main()

# vim: set ts=2 sts=2 sw=2:
