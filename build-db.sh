#!/usr/bin/env bash
#
# Script name: build-db.sh
# Description: Script for rebuilding the database for ArchN00B-core-repo.
# Github: https://www.github.com/archn00b
# Contributors: ArchN00B

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

x86_pkgbuild=$(find ../archnoob-pkgbuild/x86_64 -type f -name "*.pkg.tar.zst*")

for x in ${x86_pkgbuild}
do
    mv "${x}" x86_64/
    echo "Moving ${x}"
done

echo "###########################"
echo "Building the repo database."
echo "###########################"

## Arch: x86_64
cd x86_64
rm -f core-repo*

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry
repo-add -s -n -R core-repo.db.tar.gz *.pkg.tar.zst

# Removing the symlinks because GitLab can't handle them.
rm core-repo.db
rm core-repo.db.sig
rm core-repo.files
rm core-repo.files.sig

# Renaming the tar.gz files without the extension.
mv core-repo.db.tar.gz core-repo.db
mv core-repo.db.tar.gz.sig core-repo-db.sig
mv core-repo.files.tar.gz core-repo.files
mv core-repo.files.tar.gz.sig core-repo.files.sig

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
