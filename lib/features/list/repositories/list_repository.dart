import 'package:dio/dio.dart';

class ListRepository {
  final String _baseUrl = 'https://trainee.landa.id/javacode/menu/all';

  final Map<String, String> _headers = {
    'token': '5b90e85d28255df4e6c4e57053d0a87063157de3'
  };

  final Dio _dio = Dio();
  List<Map<String, dynamic>> data = []; // Tambahkan penyimpanan data

  // Fetch list of data from API
  Future<List<Map<String, dynamic>>> fetchMenuList() async {
    try {
      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");

        data = List<Map<String, dynamic>>.from(
          (response.data['data'] as List).map((menu) => {
                'id_menu': menu['id_menu'],
                'nama': menu['nama']?.toString() ?? "Tanpa Nama",
                'kategori': menu['kategori']?.toString() ?? "Tanpa Kategori",
                'harga': menu['harga'] ?? 0, 
                'deskripsi':
                    menu['deskripsi']?.toString() ?? "Tidak ada deskripsi",
                'foto': (menu['foto'] != null &&
                        menu['foto'].toString().trim().isNotEmpty)
                    ? menu['foto'].toString()
                    : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                'status':
                    menu['status'] ?? 0,
              }),
        );

        return data; 
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching menu: $e');
    }
  }
}
