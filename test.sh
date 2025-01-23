#!/bin/bash
if [ -d ./test ]; then
    rm -rf ./test
fi
helm template --debug --release-name popeye --values values.yaml --output-dir ./test ./