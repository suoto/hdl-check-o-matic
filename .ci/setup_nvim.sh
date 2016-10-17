#!/usr/bin/env bash

set -x

if [ "${VERSION}" == "master" ]; then
  if [ ! -f "${CACHE}/neovim-master" ]; then
    git clone https://github.com/neovim/neovim --depth 1 "${CACHE}/neovim-master"
  else
    cd "${CACHE}/neovim-master" && git pull && cd -
  fi
elif [ ! -f "${CACHE}/neovim-${VERSION}" ]; then
  wget "https://github.com/neovim/neovim/archive/v${VERSION}.tar.gz" \
    -O "${CACHE}/neovim.tar.gz"
  cd "${CACHE}"
  tar zxvf "neovim.tar.gz"
fi

if [ ! -f "${CACHE}/neovim-${VERSION}/build/bin/nvim" ]; then
  cd "${CACHE}/neovim-${VERSION}"
  make clean
  make CMAKE_BUILD_TYPE=Release -j4
fi

export PATH="${CACHE}/neovim-${VERSION}/build/bin:${PATH}"
export VIM="${CACHE}/neovim-${VERSION}/runtime"

cd "${TRAVIS_BUILD_DIR}"

# Ensure the binary being selected is the one we want
if [ ! "$(which nvim)" -ef "${CACHE}/neovim-${VERSION}/build/bin/nvim" ]; then
  echo "Neovim binary points to \"$(which nvim)\" but it should point to \
        \"${CACHE}/neovim-${VERSION}/build/bin/nvim\""
  exit -1
fi

set +x

nvim --version

