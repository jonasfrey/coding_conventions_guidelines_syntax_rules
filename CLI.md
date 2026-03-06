# CLI script standard archtiecture
Every script you write that is callable from the terminal (e.g. `python3 my_script.py param1 param2`) MUST follow this architecture standard. Apply it unconditionally — no exceptions.

## 1. Dependency Guard (runs first, before anything else)

On import failure, print clear installation instructions to stdout and exit with a non-zero code. Always recommend a virtual environment for Python.

Example:

try:
    import cv2
except ImportError:
    print("Missing required package: opencv-python")
    print("\nUse a virtual environment:\n")
    print("  python3 -m venv venv")
    print("  source venv/bin/activate")
    print("  pip install opencv-python")
    sys.exit(1)

## 2. Argument Parsing & Summary

Use the language's standard argument parser (e.g. `argparse` for Python, `clap` for Rust). Immediately after parsing, print a compact table to stdout listing every argument with:
- Name
- Whether it was explicitly provided or fell back to default
- Current value

Example output:

  ┌ Arguments ─────────────────────────────────┐
  │ --input     /imgs/scan   (provided)        │
  │ --output    ./out        (default)         │
  │ --overlap   0.3          (default)         │
  │ --verbose   True         (provided)        │
  └────────────────────────────────────────────┘

## 3. Processing with Logging & Timing

During execution:
- Print human-readable progress and status messages to stdout (prefixed with timestamps).
- Wrap every significant processing function with a timer. After each completes, log the elapsed time.

Example log lines:

  [00:00.000] Loading 12 images from /imgs/scan ...
  [00:01.342] Loaded 12 images (1.342s)
  [00:01.342] Running pairwise feature matching ...
  [00:08.771] Feature matching complete (7.429s)

At the end of all processing, print a timing summary:

  ┌ Performance ───────────────────────────────┐
  │ load_images          1.342s                │
  │ feature_matching     7.429s                │
  │ homography           0.214s                │
  │ blending             3.008s                │
  │ ────────────────────────────               │
  │ Total               11.993s                │
  └────────────────────────────────────────────┘

## 4. Machine-Readable Output (IPC Protocol)

When the script needs to communicate structured data to a calling program, it writes tagged encoded blocks to stdout. This allows a parent process to parse machine data from the same stream as human-readable logs.

**Protocol:**
- Read `S_UUID` from a `.env` file in the working directory (or accept it via an `--s-uuid` argument).
- Wrap every machine-readable payload with start/end tags on their own lines:

{S_UUID}_start_{FORMAT}
{payload}
{S_UUID}_end_{FORMAT}

- `{FORMAT}` is the encoding format in lowercase (e.g. `json`, `csv`, `base64`).
- The preferred and default format is `json`.
- The payload must be valid for its declared format.
- Each tag line and the payload MUST be on separate lines (3 lines minimum per block).

Example (assuming S_UUID=`a8f3b2c1`):

a8f3b2c1_start_json
{"status": "complete", "output_path": "/out/stitched.png", "pairs_matched": 11, "elapsed_s": 11.993}
a8f3b2c1_end_json

Multiple blocks may be emitted during a single run (e.g. progress updates, intermediate results, final output).

## 5. Exit Code

- Exit `0` on success.
- Exit `1` on missing dependencies or invalid arguments.
- Exit `2` on processing errors.

## Summary of Execution Order

1. Dependency guard → fail fast with install instructions
2. Parse arguments → print argument summary table
3. Run processing → log progress with timestamps, time each major function
4. Emit machine-readable output → tagged IPC blocks via stdout
5. Print performance summary → timing table
6. Exit with appropriate code


------
in each file with source code as the very first line (if possible)
add the comment line `// Copyright (C) [year] [Jonas Immanuel Frey] - Licensed under [license]. See LICENSE file for details`

-----
When reading source code, if you come accros inline comments beginning with `aifix` (variants: `aifix:`, `aifix :`, `aifix   ` with any spacing). These mark a location that needs special attention. The comment itself describes the issue or desired change; the few lines of code immediately following it are the relevant context to fix.

------

with each answer make a minimal one liner summary of what you did and put it in AI_responses_summaries.md in a format like this for example: 
2025-02-06 15:53:12 - created frontend page with path string input and gui output
2025-02-06 17:23:40 - created function for converting videos to files
