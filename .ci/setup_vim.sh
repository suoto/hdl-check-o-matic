#!/usr/bin/env bash

set -x

# Clone repo if the cached folder doesn't exists
if [ ! -d "${CACHE}/vim-${VERSION}" ]; then
  git clone https://github.com/vim/vim "${CACHE}/vim-${VERSION}"
fi


if [ ! -f "${CACHE}/vim-${VERSION}/src/vim" -o "${VERSION}" == "master" ]; then
  cd "${CACHE}/vim-${VERSION}"
  if [ "${VERSION}" == "master" ]; then
    # If we're testing the latest Vim version, we only pull the latest changes
    git clean -fdx
    git checkout master
    git pull
  else
    git checkout "${VERSION}"
  fi
  ./configure --with-features=huge --enable-pythoninterp --enable-gui=auto --with-x

  make all -j4
fi

cd "${TRAVIS_BUILD_DIR}"

$VIM_BINARY --version

