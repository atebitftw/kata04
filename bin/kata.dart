// Copyright (c) 2015, John Evans (prujohn@gmail.com). All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:kata_util/kata_util.dart' as _;
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';

final Logger _l = new Logger("kata");
final Level _logLevel = Level.WARNING;

const String weather = 'http://codekata.com/data/04/weather.dat';
const String football = 'http://codekata.com/data/04/football.dat';

main(List<String> arguments) async {

  _initLogging();
  final parser = _initParser();
  final results = parser.parse(arguments);

  if (results.rest.isEmpty)
  {
    var ec = _error("\nSomething is wrong with your"
    " supplied arguments.  Need to supply a url along with options for generating a report. ");
    _showUsage(parser);
    exit(ec);
  }

  final rawData = await _.getFileFromUri(results.rest[0]);

  if (rawData == null){
    _l.warning("Unable to open file ${results.rest[0]}");
    exit(_error("Unable to open file at: ${results.rest[0]}"));
  }

  if (results.arguments.length == 1) {
    print(rawData);
    exit(0);
    return;
  }

  if (results['analyze']){
    _l.info('runnig analysis report');
    print('\nAnalysis report for: ${results.rest[0]}');
    _.prints(_.analyze(rawData, ignoreLast: results['ignorelast']));
    exit(0);
    return;
  }
}

void _showUsage(ArgParser p){
  print("\nUsage:\ndart kata.dart [url to data]    Prints the raw data to the console.");
  print("dart kata.dart [url to data] {options}    See below for various options and flags.\n");
  print(p.usage);
}

ArgParser _initParser()
{
  final parser = new ArgParser();

  parser.addFlag('ignorelast', abbr: 'i', help: "Ignores the last row of the data set.  "
  "Useful for throwing away, summary rows.");

  parser.addFlag('analyze', help: "Outputs an analysis of the data and it's structure.");

  return parser;
}

int _error(String message){
  _.prints(message);
  return 1;
}

void _initLogging(){
  Logger.root.level = _logLevel;

  Logger.root.onRecord.listen((LogRecord lr){
    _.prints('${lr.level.name}: ${lr.message}');
  });
}