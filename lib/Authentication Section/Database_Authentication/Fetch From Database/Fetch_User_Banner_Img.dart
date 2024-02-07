import 'package:firebase_database/firebase_database.dart';

Future<Map<String, double?>> getBannerImgUrl(String bannerImgId) async {
  try {
    DataSnapshot bannerImgRef = (await FirebaseDatabase.instance
            .ref()
            .child('Img-Urls')
            .child(bannerImgId)
            .child('Post-Banner-IMG-Url')
            .once())
        .snapshot;

    dynamic banner = bannerImgRef.value;

    if (bannerImgRef.value != null) {
      // Cast the value to Map<String, dynamic> first
      Map<String, double?> convertedValue = banner.cast<String, double?>();

      return convertedValue;
    } else {
      return {'not': 0}; // Return null if no data is found
    }
  } catch (e) {
    print("Error retrieving banner image URL: $e");
    return {'not': 0};
  }
}
