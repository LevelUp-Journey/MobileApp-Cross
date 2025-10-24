import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import '../environments/environment.dart';

class CloudinaryService {
  final CloudinaryPublic _cloudinary;

  CloudinaryService()
      : _cloudinary = CloudinaryPublic(
          Environment.cloudinaryCloudName,
          'levelup_journey', // This is the upload preset name, you might need to change it
          cache: true,
        );

  Future<String> uploadImage(String imagePath) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint(e.message); // Log the error message
      throw Exception('Failed to upload image to Cloudinary');
    }
  }
}
