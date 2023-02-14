#!/bin/bash

git clone --recurse-submodules https://github.com/bigshans/hugo-blog.git
cd hugo-blog && cp ./.hooks/pre-push ./.git/hooks
