// Copyright (c) 2015, John Evans (prujohn@gmail.com). All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:kata_util/kata_util.dart' as kata;
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';

final Logger _l = new Logger("kata.app");
Level _logLevel = Level.SEVERE;

// http://codekata.com/data/04/weather.dat
// http://codekata.com/data/04/football.dat

main(List<String> arguments) async {

  _initLogging();
  final parser = _initArgParser();
  final results = parser.parse(arguments);

  if (results['warnings']){
    Logger.root.level = Level.WARNING;
  }

  if (results.wasParsed('help')){
    print(parser.usage);
    exit(0);
    return;
  }

  if (!results.wasParsed('url')){
    print(parser.usage);
    exit(1);
    return;
  }

  final rawData = await kata.getFileFromUri(results['url']);

  if (rawData == null){
    _l.severe("Unable to open ${results['url']}");
    exit(1);
    return;
  }

  if (results['coerce'] && results['strict']){
    print("Data cannot be coerced with --coerce flag when --strict flag is used.");
    exit(1);
    return;
  }

  if (results['analyze']){
    print('\nAnalysis report for: ${results["url"]}');
    print(kata.analyze(rawData, ignoreLast: results['ignorelast']));
  }

  if (results.wasParsed('query')){
    if (!results.wasParsed('cols')){
      _l.severe("No columns specified for query.  Use --cols=col1,col2,...");
      exit(1);
      return;
    }

    final cols = (results['cols'] as String).split(',');
    _l.fine("cols given: ${cols}");

    var disp = [];

    if (results.wasParsed('disp')){
      disp = (results['disp'] as String).split(',');
    }

    _l.fine("display columns given: ${disp}");

    final queryResult = kata.query(
          rawData,
          results['query'],
          cols,
          disp,
          coerce: results['coerce'],
          ignoreLast: results['ignorelast'],
          strict: results['strict']
      );

    if (queryResult.containsKey('error')){
      _l.warning(queryResult['error']);
      print(queryResult);
      exit(1);
      return;
    }

    print(queryResult);

    exit(0);
    return;
  }

  //only url supplied so just dump it out.
  print(rawData);
  exit(0);
}

ArgParser _initArgParser()
{
  final parser = new ArgParser();

  parser.addFlag('help', defaultsTo: false, help: "Displays Usage");

  parser.addFlag('analyze', defaultsTo: false, help: "Outputs an analysis of the data and it's structure.");

  parser.addFlag('ignorelast', defaultsTo: false, help: "Ignores the last row of the data set.  "
  "Useful for throwing away, summary row.");

  parser.addFlag('strict', defaultsTo: false, help: "Forces query to fail if there any problems with the data.");

  parser.addFlag('coerce', defaultsTo: false, help:
    "Instructs the query command to attempt to coerce data elements into the correct type.");

  parser.addOption('url', help: "Url to the data. (ex. --url=http://codekata.com/data/04/weather.dat)");

  parser.addOption('query', help: 'The query name to run against the data. (ex. --query=smallest_spread)');

  parser.addOption('cols', help: 'Comma delimited list of columns for the query to use.'
    '  Can use column header name or column position 0-n.');

  parser.addOption('disp', help: 'Comma delimited list of columns to disply on query output.'
    ' Leave blank to see default query result.');

  parser.addFlag("warnings", defaultsTo: false, help: "Show warnings. Might help discover data integrity issues.");

  return parser;
}

void _initLogging(){
  Logger.root.level = _logLevel;

  Logger.root.onRecord.listen((LogRecord lr){
    print('${lr.level.name}(${lr.loggerName}): ${lr.message}');
  });
}