#!/usr/bin/env bash
set -e

NOTICE="# DO NOT EDIT THIS FILE ON PLATFORM: THIS ACTOR IS BUILT AUTOMATICALLY FROM github.com\/mvolfik\/apify-argos-translator-actor\n"

rm -rf build
mkdir build

cd runner-template
FILES=$(find . -type f)
cd ..

no_wait_for_build=""

echo "Building all actors for version '$TARGET_VERSION' with base image digest '$BASE_IMAGE_DIGEST'"

for lang_code in $(jq -r 'keys | join("\n")' config.json); do
    lang_name=$(jq -r ".$lang_code.name" config.json)
    localized_actor_title=$(jq -r ".$lang_code.localizedActorTitle" config.json)
    # using tr for \n to % and then sed for escaped newlines is an atrocity, but it's 10:30pm when I'm writing this
    prefills=$(jq ".$lang_code.prefills" config.json | sed 's/\\n/\\\\n/g' | tr '\n' '%' | sed 's/%/\\n/g')

    echo "Building $lang_code ($lang_name)"
    cp -r runner-template build/$lang_code

    cd build/$lang_code

    sed -i "1s/^/$NOTICE/" src/*.py

    sed -i 's/${BASE_IMAGE_DIGEST}/'"$BASE_IMAGE_DIGEST/g" .actor/Dockerfile
    sed -i 's/${LANG_CODE}/'"$lang_code/g" $FILES
    sed -i 's/${LANG_NAME}/'"$lang_name/g" $FILES
    sed -i 's/${LOCALIZED_ACTOR_TITLE}/'"$localized_actor_title/g" $FILES
    sed -i 's/${PREFILLS}/'"$prefills/g" $FILES

    apify push -b $TARGET_VERSION $no_wait_for_build | tee ../$lang_code.log
    if grep -Fe "Error: Build failed!" ../$lang_code.log; then
        echo "Build failed, aborting"
        exit 1
    fi

    # we waited for first build to see that nothing is broken, the rest can run in parallel
    no_wait_for_build="-w1"
    cd ../..
done
