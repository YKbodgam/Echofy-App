import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../Classes ( New ) Section/Create_New_Stories_Class.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

// Step 1: Create a list named as original list containing all the stories
Future<List<dynamic>> getallStories(String userId) async {
  List<Stories> originalList = [];
  List<dynamic> finalList = [];

  DataSnapshot storySnapshot =
      (await _databaseReference.child('Stories').once()).snapshot;
  dynamic storyMapDynamic = storySnapshot.value;

  if (storyMapDynamic != null && storyMapDynamic is Map) {
    storyMapDynamic.forEach((storyKey, storyValue) {
      if (storyKey is String && storyValue is Map<Object?, Object?>) {
        DatabaseReference? storyRef;
        try {
          storyRef = _databaseReference.child('Stories/$storyKey');
        } catch (e) {
          print('Error creating DatabaseReference: $e');
        }

        if (storyRef != null) {
          Map<String, dynamic> convertedValue =
              storyValue.cast<String, dynamic>();
          try {
            Stories story = createStories(convertedValue, storyRef);
            originalList.add(story);
          } catch (e) {
            print('Error parsing story: $e');
          }
        }
      }
    });
  }

// Helper function to check if a DateTime is within the last 24 hours
  bool isWithin24Hours(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(dateTime);
    return difference.inHours <= 24;
  }

// Step 3: Remove stories older than 24 hours from the originalList
  originalList.removeWhere((story) {
    DateTime storyDateTime = parseDateTime(story.storyDate, story.storyTime);
    return !isWithin24Hours(storyDateTime);
  });

  // Step 3: Group stories by writer
  Map<String, List<Stories>> groupedByWriter = {};
  for (var story in originalList) {
    groupedByWriter.putIfAbsent(story.storyAuthorId, () => []).add(story);
  }

  // Step 4: Combine stories with the same writer into sublist and put it at the top
  groupedByWriter.forEach((writer, sublist) {
    if (sublist.length > 1) {
      finalList.insert(0, sublist);
    }
  });

  // Step 5: Sort all the stories in each sublist according to their Posted Time
  groupedByWriter.forEach((writer, sublist) {
    sublist.sort((a, b) {
      DateTime aDateTime = parseDateTime(a.storyDate, a.storyTime);
      DateTime bDateTime = parseDateTime(b.storyDate, b.storyTime);
      return aDateTime.compareTo(bDateTime);
    });
  });

  // Step 6: If the writer has only one story, sort it in the original list according to its Posted Time
  groupedByWriter.forEach((writer, sublist) {
    if (sublist.length == 1) {
      finalList.insert(0, sublist.first);
    }
  });

  // Step 7: Compare the writer of the stories with the provided username and bring matching stories to the top
  finalList.sort((a, b) {
    String writerA = (a is Stories)
        ? a.storyAuthorId
        : (a as List<Stories>).last.storyAuthorId;
    String writerB = (b is Stories)
        ? b.storyAuthorId
        : (b as List<Stories>).last.storyAuthorId;

    if (writerA == userId) {
      return -1; // User's stories come first
    } else if (writerB == userId) {
      return 1; // User's stories come first
    }

    DateTime aDateTime = (a is Stories)
        ? parseDateTime(a.storyDate, a.storyTime)
        : parseDateTime(
            (a as List<Stories>).last.storyDate, (a).last.storyTime);
    DateTime bDateTime = (b is Stories)
        ? parseDateTime(b.storyDate, b.storyTime)
        : parseDateTime(
            (b as List<Stories>).last.storyDate, (b).last.storyTime);

    return bDateTime.compareTo(aDateTime);
  });

  return finalList;
}

// Helper function to parse DateTime from date and time strings
DateTime parseDateTime(String dateString, String timeString) {
  DateTime date = DateFormat('EEE, MMM dd, yyyy').parse(dateString);
  TimeOfDay time = parseTime(timeString);

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

// Helper function to parse TimeOfDay from time string
TimeOfDay parseTime(String timeString) {
  List<String> parts = timeString.split(' ');
  List<String> timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  if (parts[1].toLowerCase() == 'pm' && hour < 12) {
    hour += 12;
  }

  return TimeOfDay(hour: hour, minute: minute);
}
