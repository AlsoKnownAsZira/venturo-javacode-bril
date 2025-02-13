import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ProfileRepository {
  final String _baseUrl = 'https://trainee.landa.id/javacode/user/all';
  final Map<String, String> _headers = {
    'token': '5b90e85d28255df4e6c4e57053d0a87063157de3'
  };
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      var box = Hive.box('venturo');
      final email = (box.get('email') as String?)?.trim().toLowerCase();

      print('Retrieved email from Hive box: $email');

      if (email == null) {
        throw Exception('Email not found in Hive box');
      }

      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        final users = response.data['data'] as List;
        final user = users.firstWhere(
          (user) => (user['email'] as String?)?.trim().toLowerCase() == email,
          orElse: () => null,
        );

        if (user != null) {
          return user;
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return {};
    }
  }
}