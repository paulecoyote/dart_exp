#!/bin/bash

# Grab source directory of this script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
EXPERIMENT_DIR="$( dirname "$SOURCE_DIR" )";
PAGES_DIR="$EXPERIMENT_DIR-pages"
COPY_RELEASE_DIR_ARGS="-R"

# Use source directory to output git hash as version
# NOTE: If you are not storing your copy in git you can just delete the following section
# -----------------------
pushd $SOURCE_DIR > /dev/null
VERSION_UNCOMMITTED_CHANGES=$(git status | grep 'modified:' | wc -l)
if [ "$VERSION_UNCOMMITTED_CHANGES" -gt "0" ] ; then
    echo -e "release_exp.sh ID `git rev-parse HEAD`  $VERSION_UNCOMMITTED_CHANGES local change(s)\n"
else
    echo -e "release_exp.sh ID `git rev-parse HEAD`\n"
fi
popd > /dev/null
# -----------------------

show_help() {
cat << EOF

Usage: ${0##*/} [-h] [-e EXPERIMENT_DIR -p PAGES_DIR -v RELEASE_VERSION]

Do not use trailing slash for directory arguments.
    
    -h                          display this help and exit
    -e EXPERIMENT_DIR           experiment being released folder
    -p PAGES_DIR                checked out pages directory
    -v RELEASE_VERSION          semantic version e.g. v0.1.0

EXPERIMENT_DIR defaults to the grandparent directory of this script
PAGES_DIR defaults to EXPERIMENT_DIR postfixed with -pages
RELEASE_VERSION uses the last git tag of experiment starting with v
EOF
}

# pass the status code ($?) as an argument, and this will die with an error.
exit_on_failure() {
  STATUS=$1
  if [ $STATUS -ne 0 ]; then
    echo -e "\nBUILD FAILED\n"
    popd > /dev/null
    exit 1
  fi
}

# parse cli args and screen for invalid args
while getopts "he:p:v:r" opt; do
  case "$opt" in
    h)
      show_help
      exit 0
      ;;
    e)
      EXPERIMENT_DIR=$OPTARG
      ;;
    p)
      PAGES_DIR=$OPTARG
      ;;
    v)
      RELEASE_VERSION=$OPTARG
      ;;
    '?')
      show_help >&2
      exit 1
      ;;
  esac
done

# Change to root directory of experiment
pushd $EXPERIMENT_DIR > /dev/null

if [ -z "$RELEASE_VERSION" ]; then  
    RELEASE_VERSION=$(git describe --abbrev=0 --tags | grep '^v')
    if [ -z "$RELEASE_VERSION" ]; then exit_on_failure 1; fi
fi

echo -e "\nBuilding experiment $RELEASE_VERSION"
echo -e "Source directory: $EXPERIMENT_DIR"
DESTINATION_DIR="$PAGES_DIR/v/$RELEASE_VERSION"
echo -e "Destination directory: $DESTINATION_DIR"

# Pub needs to be run from the root of the dart project
pub build
exit_on_failure $?

# Copy 
cp $COPY_RELEASE_DIR_ARGS build/web $DESTINATION_DIR
exit_on_failure $?

cd $DESTINATION_DIR

git add $DESTINATION_DIR
GIT_COMMIT_MSG="'$RELEASE_VERSION build updated'"
git commit -m "$GIT_COMMIT_MSG"
git push origin gh-pages

# Restore dir
popd > /dev/null