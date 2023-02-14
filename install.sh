#!/bin/bash

git clone --recurse-submodules https://github.com/bigshans/hugo-blog.git
cp ./.hooks/pre-push ./.git/hooks
