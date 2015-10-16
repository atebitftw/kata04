// Copyright (c) 2015, John Evans (prujohn@gmail.com). All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library kata.app.test;

import 'package:kata/kata_app.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
