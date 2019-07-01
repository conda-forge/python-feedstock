#!/usr/bin/env bash

set -x

curl https://raw.githubusercontent.com/conda-forge/conda-forge-ci-setup-feedstock/master/recipe/conda_forge_ci_setup/ff_ci_pr_build.py | \
     python - -v --ci "circle" "${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}" "${CIRCLE_BUILD_NUM}" "${CIRCLE_PR_NUMBER}"

echo "Removing homebrew from CI to avoid conflicts." && echo -en 'travis_fold:start:remove_homebrew\\r'
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall > ~/uninstall_homebrew
chmod +x ~/uninstall_homebrew
~/uninstall_homebrew -fq
rm ~/uninstall_homebrew
echo -en 'travis_fold:end:remove_homebrew\\r'

echo "Installing a fresh version of Miniconda." && echo -en 'travis_fold:start:install_miniconda\\r'
MINICONDA_URL="https://repo.continuum.io/miniconda"
MINICONDA_FILE="Miniconda3-latest-MacOSX-x86_64.sh"
curl -L -O "${MINICONDA_URL}/${MINICONDA_FILE}"
bash $MINICONDA_FILE -b
echo -en 'travis_fold:end:install_miniconda\\r'

echo "Configuring conda." && echo -en 'travis_fold:start:configure_conda\\r'
source ~/miniconda3/bin/activate root

conda install -n root -c conda-forge --quiet --yes conda-forge-ci-setup=2 conda-build
mangle_compiler ./ ./recipe .ci_support/${CONFIG}.yaml
setup_conda_rc ./ ./recipe ./.ci_support/${CONFIG}.yaml


source run_conda_forge_build_setup


echo -en 'travis_fold:end:configure_conda\\r'

set -e

make_build_number ./ ./recipe ./.ci_support/${CONFIG}.yaml

conda build ./recipe -m ./.ci_support/${CONFIG}.yaml --clobber-file ./.ci_support/clobber_${CONFIG}.yaml

upload_package ./ ./recipe ./.ci_support/${CONFIG}.yaml