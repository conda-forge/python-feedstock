### How to re-generate patches

Use the existing series from the target feedstock branch and the CPython tags
for its old and new releases. The example below assumes sibling `cpython` and
`python-feedstock` checkouts; adjust the paths and tags as needed.

```bash
old=v3.12.14
new=v3.12.15
git clone https://github.com/python/cpython.git
cd cpython
git switch -c feedstock-patches "$old"
git am -3 ../python-feedstock/recipe/patches/*.patch
git rebase --onto "$new" "$old"
```

The glob selects only patch files in numbered order. Apply all patches, including
those selected only on other platforms in the recipe. `git am -3` can fall back
to a three-way merge when the required Git blobs are available.

Resolve any rebase conflicts, preserving the intended patch changes and file
line endings. Do not let an editor add a final newline to a file that lacks one.
Stage each resolution and run `git rebase --continue`.

Export to a separate directory so generated patches are not mixed with the old
series, then restore the mixed line endings required by Windows patches:

```bash
mkdir ../refreshed-patches
git format-patch --no-signature -o ../refreshed-patches "$new"
for f in ../refreshed-patches/*.patch; do
  python ../python-feedstock/recipe/patches/make-mixed-crlf-patch.py "$f"
done
```

For Windows Command Prompt, the application step has this equivalent (use `%%f`
instead of `%f` in a batch file):

```bat
for /f "delims=" %f in ('dir /b /s /on ..\python-feedstock\recipe\patches\*.patch') do git am -3 "%f"
```

Before replacing the feedstock's patches, verify the exported series with
`git am` on a clean checkout of the new tag:

```bash
git worktree add --detach ../cpython-patch-check "$new"
git -C ../cpython-patch-check am ../refreshed-patches/*.patch
git diff HEAD "$(git -C ../cpython-patch-check rev-parse HEAD)" --exit-code
```

The final check confirms that applying the exported patches reproduces the
rebased source tree. Preserve patch authorship, metadata, ordering, and recipe
references when copying the regenerated series back to the feedstock.
