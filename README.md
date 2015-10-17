[![Build Status](https://travis-ci.org/prujohn/kata04.svg?branch=master)](https://travis-ci.org/prujohn/kata04)

# Kata04 App

Application for the Kata04 exercise.

http://codekata.com/

## Why Dart?
I like Dart because it's a modern programming language.  Most people associated it with client-side web programming,
but Dart also has a powerful server side VM, which I use for this project.

This is a command line dart app (bin/kata.dart) which calls into a library.  The library handles data parsing and queries.  It
supports one predefined query 'smallest_spread' which can be run against any loosely columned textual data that contains
a well-formed header row.

The library can be found here: https://github.com/prujohn/kata04-util

## Assumptions
That you have dart installed.  www.dartlang.org

## Usage
    dart kata.dart --help

## Running A Query
For the weather.dat file:
    dart kata.dart --ignorelast --query=smallest_spread --url=http://codekata.com/data/04/weather.dat --cols=MnT,MxT --disp=Dy --coerce

For the football.dat file:
    dart kata.dart --query=smallest_spread --url=http://codekata.com/data/04/football.dat --cols=F,A --disp=Team --coerce

## Compliance
### Use Gradle wrapper
Dart uses a package/manifest tool called "pub" for this.  See pubspec.yaml

###  Set up a basic project
Done.

### Package your project, complete with manifest information
Dart's pub tool handles this.  See pubspec.yaml

### Have a proper dependency handling to external libraries
Dependencies are listed in pubspec.yaml

### Publish Test Report, also, print test execution outcome to command line so it's visible on the Travis CI console log
Done.