import 'package:dio/dio.dart';
import 'package:venturo_core/features/list/constants/list_api_constant.dart';

class PromoRepository {
  // PromoRepository._();

  var apiConstant = ListApiConstant();
  final String _baseUrl = 'https://trainee.landa.id/javacode/promo/all';
  final Map<String, String> _headers = {
    'token': '5b90e85d28255df4e6c4e57053d0a87063157de3'
  };
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchPromoList() async {
    try {
      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> promoList = [];
        for (var promo in response.data['data']) {
          promoList.add({
            'id_promo': promo['id_promo'] as int?,
            'nama': promo['nama'] as String?,
            'type': promo['type'] as String?,
            'diskon': promo['diskon'] as int?,
            'nominal': promo['nominal'] as int?,
            'kadaluarsa': promo['kadaluarsa'] as int?,
            'syarat_ketentuan': promo['syarat_ketentuan'] as String?,
            'foto': promo['foto'] as String?,
            'created_at': promo['created_at'] as int?,
            'created_by': promo['created_by'] as int?,
            'is_deleted': promo['is_deleted'] as int?,
          });
        }
        return promoList;
      } else {
        throw Exception('Failed to load promo list');
      }
    } catch (e) {
      print('Error fetching promo list: $e');
      return [];
    }
  }
}