#!/usr/bin/env bash
#
# Script name: build-db.sh
# Description: Script for rebuilding the database for ArchN00B-core-repo.
# Github: https://www.github.com/archn00b
# Contributors: ArchN00B

# Enable strict error handling
set -euo pipefail

# Find all package files
x86_pkgbuild=$(find ../archnoob-pkgbuild/x86_64 -type f -name "*.pkg.tar.zst*")

# Move package files to the x86_64 directory
for pkg in ${x86_pkgbuild}; do
    mv "${pkg}" x86_64/
    echo "Moving ${pkg}"
done

echo "###########################"
echo "Building the repo database."
echo "###########################"

# Navigate to the x86_64 directory and prepare for building
cd x86_64 || exit
rm -f core-repo*

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

# Build the repository database
repo-add -s -n -R core-repo.db.tar.gz -- *.pkg.tar.zst

# Remove symlinks as GitLab can't handle them
rm -f core-repo.db core-repo.db.sig core-repo.files core-repo.files.sig

# Rename the tar.gz files without the extension
for file in core-repo.db.tar.gz core-repo.files.tar.gz; do
    mv "${file}" "${file%.tar.gz}"
done

# Rename signature files
mv core-repo.db.sig core-repo-db.sig
mv core-repo.files.sig core-repo.files.sig

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
