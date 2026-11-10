"""Prints per-case mean scores with and without the plugin from a `claude plugin eval --json` file.

Usage: python3 evals/table.py evals/results/<run>.json
"""
import json
import sys

result = json.load(open(sys.argv[1]))
print(f"cost ${result['costUsd']:.2f}\n")
print(f"{'case':26} {'WITH':>5} {'W/OUT':>6} {'delta':>6}  runs")
with_total = without_total = 0
for case in result["cases"]:
    with_scores = [run["score"] for run in case["arms"].get("with", [])]
    without_scores = [run["score"] for run in case["arms"].get("without", [])]
    with_mean = sum(with_scores) / len(with_scores)
    without_mean = sum(without_scores) / len(without_scores) if without_scores else 0
    with_total += with_mean
    without_total += without_mean
    print(f"{case['name']:26} {with_mean:5.2f} {without_mean:6.2f} {with_mean - without_mean:+6.2f}  {len(with_scores)}")
count = len(result["cases"])
print(f"{'MEAN':26} {with_total / count:5.2f} {without_total / count:6.2f} {(with_total - without_total) / count:+6.2f}")
print()
for case in result["cases"]:
    for index, run in enumerate(case["arms"].get("with", [])):
        for grader in run["graders"]:
            if not grader["passed"] and grader.get("scored", True):
                print(f"WITH FAIL  {case['name']} #{index + 1}  {grader['name']}: {grader.get('explanation', '')[:150]}")
