#!/usr/bin/env bash

base=$(pwd)
dir=$1
shift 1

mkdir -p $dir
cd $dir
cp $base/Gemfile .
ruby -v | perl -e '/^ruby\ ((\d+\.?)+)/ && print $1' -n > .ruby-version
bundle install
bundle exec rails new -T -d postgresql -m $base/template.rb -f "$@" .
