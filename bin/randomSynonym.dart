// randomSynonym.dart
// Ryan Stonebraker
// Gets a word from user and finds a synonym by webscraping using the dart:html
// library.

import "dart:io";
import 'dart:math';
import 'package:http/http.dart' as http;

List getDelimitedList(String rawString, String delimiter) {
  var delimitedList = rawString.split("\n");
  for (var i = 0; i < delimitedList.length; ++i) {
    if (delimitedList[i].length > delimiter.length) {
      int delimiterEnd = delimitedList[i].indexOf(delimiter) + delimiter.length;
      delimitedList[i] = delimitedList[i].substring(delimiterEnd);
    }
    else {
      delimitedList.removeAt(i);
    }
  }
  return delimitedList;
}

void printRandomSyn(dynamic syns) {
  syns = getDelimitedList(syns, "syn|");
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

String getSanitizedInput() {
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
