# Agent guidance

## Updating Python and its patches

Before preparing a Python version bump or editing `recipe/patches/*.patch`, read
[the patch regeneration instructions](recipe/patches/README.md) and
[`make-mixed-crlf-patch.py`](recipe/patches/make-mixed-crlf-patch.py) on the target
version branch. If either is absent, consult the corresponding file on upstream
`main`. The repository's patch instructions are authoritative.

Regenerate patches through the documented CPython Git workflow: apply the
existing series with `git am -3` on the old release tag, rebase the patch commits
onto the new tag as documented in the README and resolve conflicts, export with
`git format-patch --no-signature`, and run `make-mixed-crlf-patch.py` on the
generated patches. Preserve patch authorship, commit metadata, ordering, and
required line endings. Hand-editing patch text and confirming that it applies
does not replace this workflow.

Before committing or publishing a version bump, verify that the regenerated
series applies in order with `git am` to a clean checkout of the new CPython tag,
and run the applicable recipe and pre-commit checks. Report any checks that could
not be completed.
