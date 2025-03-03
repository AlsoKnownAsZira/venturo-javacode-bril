import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class ProfileRepository {
  final String _baseUrl = 'https://trainee.landa.id/javacode/user/detail';
  final Map<String, String> _headers = {
    'token': '5b90e85d28255df4e6c4e57053d0a87063157de3'
  };
  final Dio _dio = Dio();
  final Logger logger = Logger();

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      var box = Hive.box('venturo');
      final userId = box.get('userId');

      if (userId == null) {
        throw Exception('User ID not found in Hive box');
      }

      final response = await _dio.get(
        '$_baseUrl/$userId',
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        final user = response.data['data'] as Map<String, dynamic>;

        if (user != null) {
          logger.d('Fetched user data: $user'); // Debug user data
          return user;
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      logger.e('Error fetching user profile: $e');
      return {};
    }
  }
}