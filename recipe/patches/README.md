### How to re-generate patches

Use the existing series from the target feedstock branch and the CPython tags
for its old and new releases. The example below assumes sibling `cpython` and
`python-feedstock` checkouts; adjust the paths and tags as needed.

Run the commands in stages. If the rebase reports conflicts, resolve them before
continuing: preserve the intended patch changes and file line endings, do not
let an editor add a final newline to a file that lacks one, stage each resolution,
and run `git rebase --continue`.

```bash
old=v3.14.7
new=v3.14.8
git clone https://github.com/python/cpython.git
cd cpython
git switch -c feedstock-patches "$old"
git am -3 ../python-feedstock/recipe/patches/*.patch
git rebase --onto "$new" "$old"

# Continue here once the rebase has completed successfully.
rm *.patch
git format-patch --no-signature "$new"
for f in *.patch; do
python ../python-feedstock/recipe/patches/make-mixed-crlf-patch.py "$f"
done

# Verify the exported series on a clean checkout of the new tag.
patched_head=$(git rev-parse HEAD)
git switch --detach "$new"
git am ../refreshed-patches/*.patch
git diff "$patched_head" HEAD --exit-code

# Copy the verified patches back to the feedstock.
cp ../refreshed-patches/*.patch ../python-feedstock/recipe/patches/
```

The glob selects only patch files in numbered order. Apply all patches, including
those selected only on other platforms in the recipe. `git am -3` can fall back
to a three-way merge when the required Git blobs are available.

Exporting to a separate directory keeps generated patches apart from the old
series. The helper restores the mixed line endings required by Windows patches.
The rebased series remains on `feedstock-patches` while the exported patches are
verified in a detached checkout. The diff check must succeed before copying the
patches back; it confirms that applying them reproduces the rebased source tree.
Preserve patch authorship, metadata, ordering, and recipe references.

For Windows Command Prompt, the application step has this equivalent (use `%%f`
instead of `%f` in a batch file):

```bat
for /f "delims=" %f in ('dir /b /s /on ..\python-feedstock\recipe\patches\*.patch') do git am -3 "%f"
```
