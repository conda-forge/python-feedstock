# Agent guidance

## Updating Python and its patches

Before preparing a Python version bump or editing `recipe/patches/*.patch`, read
[the patch regeneration instructions](recipe/patches/README.md) and
[`make-mixed-crlf-patch.py`](recipe/patches/make-mixed-crlf-patch.py) on the target
version branch. If either is absent, consult the corresponding file on upstream
`main`. The repository's patch instructions are authoritative.

Follow the README's complete regeneration and validation workflow before
committing or publishing patch changes. Keep that workflow in the README rather
than duplicating it here.

Run the applicable recipe and pre-commit checks, and report any checks that could
not be completed.
