import 'dart:io';

void main() {
  print(File('test.cow').readAsStringSync());
}