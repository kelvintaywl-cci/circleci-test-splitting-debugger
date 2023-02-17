"""
Examples:
To simulate partitioning of test cases by duration:
    poetry run python cli.py --partition path/to/testcases.json
"""

import argparse
from datetime import timedelta
import json
import os

import prtpy

DISCLAIMER = """
NOTE: This does not use the same algorithm as CircleCI's `tests split` command.
This just serves as a quick sanity check to see if we can balance the nodes well.
"""


def partition(json_file: str, parallelism: int):
    """Simulates partitioning of test cases by duration into N nodes.

    Uses the Greedy Number partitioning algorithm.
    See https://en.wikipedia.org/wiki/Greedy_number_partitioning
    """
    n = parallelism
    print(f"Simulating partitioning for {n} nodes...")
    print(DISCLAIMER)

    with open(json_file, "r") as f:
        testcases = json.load(f)

    durations = [
        duration_sec for _filename_or_classname, duration_sec in testcases.items()
    ]
    parted = prtpy.partition(
        algorithm=prtpy.partitioning.greedy, numbins=n, items=durations
    )

    for i, durations in enumerate(parted, start=1):
        total_duration_secs = sum(durations)
        total_duration = timedelta(seconds=total_duration_secs)
        print(
            f"Estimated duration required when running tests for {i}th Node (HH:MM:SS):\t{total_duration}"
        )


def parse_args():
    # uses the docstring above to generate description.
    parser = argparse.ArgumentParser(
        epilog=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "json_file",
        type=str,
        help="Path to testcases JSON file",
    )
    parser.add_argument(
        "--partition",
        action="store_true",
        help="Simulate partitioning by duration",
    )
    parser.add_argument(
        "--parallelism",
        type=int,
        default=os.environ.get('PARALLELISM'),
        help="Parallelism number",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()

    if args.partition:
        partition(args.json_file, args.parallelism)
