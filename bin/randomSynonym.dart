// randomSynonym.dart
// Ryan Stonebraker
// Gets a word from user and finds a synonym by webscraping using the dart:html
// library.

import "dart:io";
import 'dart:math';
import 'package:http/http.dart' as http;

void printRandomSyn(dynamic syns) {
  var delimiter = "syn|";
  syns = syns.split("\n");
  for (var i = 0; i < syns.length; ++i) {
    if (syns[i].length > delimiter.length) {
      syns[i] = syns[i].substring(syns[i].indexOf(delimiter) + delimiter.length);
    }
    else {
      syns.removeAt(i);
    }
  }
  var randGen = new Random();
  var randomSyn = syns[randGen.nextInt(syns.length)];
  print ("Random Synonym: " + randomSyn);
}

void pageLoadError(error) {
  print ("Received the following error: ");
  print (error);
  print ("Try Again!");
  main();
}

String getSanitizedInput () {
  stdout.write ("Please Enter A Word: ");
  var userWord = stdin.readLineSync();
  userWord = userWord.toLowerCase();

  for (var i = 0; i < userWord.length; ++i) {
    if (userWord.codeUnitAt(i) < 'a'.codeUnits[0] || userWord.codeUnitAt(i) > 'z'.codeUnits[0]) {
      print("Bad Entry! Retry!");
      userWord = getSanitizedInput();
      break;
    }
  }

  return userWord;
}

void main() {
  var userWord = getSanitizedInput();
  var thesaurusBaseURL = "http://words.bighugelabs.com/api/2";
  var apiKey = "1166c33a777038684549d7422cc054fc";
  
  var fullUrl = "${thesaurusBaseURL}/${apiKey}/${userWord}/";

  http.read(fullUrl).then(printRandomSyn).catchError(pageLoadError);
}
