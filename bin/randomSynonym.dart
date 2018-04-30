// randomSynonym.dart
// Ryan Stonebraker
// Gets a word from user and finds a synonym by webscraping using the dart:html
// library.

import "dart:io";
import 'dart:math';
import 'package:http/http.dart' as http;


// Splits a raw string by newlines and then removes up to the end of a marker
// in each string.
List getScrubbedList(String rawString, String marker) {
  var delimitedList = rawString.split("\n");
  for (var i = 0; i < delimitedList.length; ++i) {
    if (delimitedList[i].length > marker.length) {
      int delimiterEnd = delimitedList[i].indexOf(marker) + marker.length;
      delimitedList[i] = delimitedList[i].substring(delimiterEnd);
    }
    else {
      delimitedList.removeAt(i);
    }
  }
  return delimitedList;
}


// Prints a random synonym from the bighugelabs thesaurus response page.
void printRandomSyn(dynamic syns) {
  syns = getScrubbedList(syns, "syn|");
  var randGen = new Random();
  var randomSyn = syns[randGen.nextInt(syns.length)];
  print ("Random Synonym: " + randomSyn);
}


// Handles errors with get request, prints error, and recurses through main
void pageLoadError(error) {
  stderr.write("Received the following error: ");
  stderr.write(error);
  stderr.write("\nTry Again!\n\n");
  main();
}


// Gets input from the user consisting only of alphabetical characters
String getSanitizedInput() {
  stdout.write ("Please Enter A Word: ");
  var userWord = stdin.readLineSync();
  if (userWord.length == 0)
    exit(0);
  userWord = userWord.toLowerCase();
  for (var i = 0; i < userWord.length; ++i) {
    if (userWord.codeUnitAt(i) < 'a'.codeUnits[0] || userWord.codeUnitAt(i) > 'z'.codeUnits[0]) {
      stderr.write("Bad Entry! Retry!\n");
      userWord = getSanitizedInput();
      break;
    }
  }
  return userWord;
}


// Gets an alphabetical word from user and uses the dart http library to find
// a synonym using a thesaurus api. The plaintext response or error is then
// handled appropriately. The program then loops.
getRandomSynonym() async {
  var userWord = getSanitizedInput();
  var thesaurusBaseURL = "http://words.bighugelabs.com/api/2";
  var apiKey = "1166c33a777038684549d7422cc054fc";

  var fullUrl = "$thesaurusBaseURL/$apiKey/$userWord/";

  await http.read(fullUrl).then(printRandomSyn).catchError(pageLoadError);
}


// Loops getting a random synonym for a user entered word.
main() async {
  while (true) {
    await getRandomSynonym();
    stdout.write("\nNewline to Exit.\n");
  }
}
