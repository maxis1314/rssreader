#!/bin/bash


git add *

git commit -m"daniel:$1"

git push -u origin master

cp RSSwift/RSSwift/DBManager.swift ../rsslib/XXX.swift

cd ../rsslib 

./commit.sh 1

cd -
