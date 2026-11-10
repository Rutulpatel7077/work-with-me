"""Prints a readable summary of a `claude plugin eval --json` result file.

Usage: python3 evals/summarize.py evals/results/<run>.json [--replies]
"""
import json
import sys


def last_reply(trace_path):
    try:
        lines = open(trace_path).read().splitlines()
    except OSError:
        return "(trace not available)"
    for line in reversed(lines):
        event = json.loads(line)
        message = event.get("message", {})
        if event.get("type") == "assistant":
            texts = [part.get("text", "") for part in message.get("content", []) if part.get("type") == "text"]
            if any(texts):
                return "\n".join(texts).strip()
    return "(no assistant text)"


def main():
    result = json.load(open(sys.argv[1]))
    show_replies = "--replies" in sys.argv
    print(f"cost ${result['costUsd']:.2f}, {result['durationSeconds']}s, partial={result['partial']}\n")
    for case in result["cases"]:
        for arm, runs in case.get("arms", {}).items():
            for index, run in enumerate(runs):
                print(f"{case['name']} [{arm} #{index + 1}] score={run['score']} turns={run['turns']} error={run['error']}")
                for grader in run["graders"]:
                    mark = "pass" if grader["passed"] else "FAIL"
                    print(f"    {mark}  {grader['name']}: {grader.get('explanation', '')[:160]}")
                if show_replies:
                    print("    --- final reply ---")
                    print("    " + last_reply(run.get("tracePath", "")).replace("\n", "\n    ")[:1800])
                print()


main()
