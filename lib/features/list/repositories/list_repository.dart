import 'package:dio/dio.dart';

class ListRepository {
  final String _baseUrl = 'https://trainee.landa.id/javacode/menu/all';
  final String _menuDetailUrl = 'https://trainee.landa.id/javacode/menu/detail/'; 

  final Map<String, String> _headers = {
    'token': '5b90e85d28255df4e6c4e57053d0a87063157de3'
  };

  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchMenuList() async {
    try {
      final response = await _dio.get(
        _baseUrl,
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> menuList = List<Map<String, dynamic>>.from(
          (response.data['data'] as List).map((menu) => {
                'id_menu': menu['id_menu'],
                'nama': menu['nama']?.toString() ?? "Tanpa Nama",
                'kategori': menu['kategori']?.toString() ?? "Tanpa Kategori",
                'harga': menu['harga'] ?? 0,
                'deskripsi': menu['deskripsi']?.toString() ?? "Tidak ada deskripsi",
                'foto': (menu['foto'] != null && menu['foto'].toString().trim().isNotEmpty)
                    ? menu['foto'].toString()
                    : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/240px-No_image_available.svg.png',
                'status': menu['status'] ?? 0,
              }),
        );

        for (var menu in menuList) {
          var details = await fetchMenuDetail(menu['id_menu']);
          menu['topping'] = details['topping'] ?? [];
          menu['level'] = details['level'] ?? [];
        }

        return menuList;
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching menu: $e');
    }
  }

  // Fetch menu details including toppings and levels
  Future<Map<String, dynamic>> fetchMenuDetail(int idMenu) async {
    try {
      final response = await _dio.get(
        '$_menuDetailUrl$idMenu', // Use the correct URL format
        options: Options(headers: _headers),
      );

       if (response.statusCode == 200) {
        var data = response.data['data'];
        print('Fetched details for menu ID $idMenu: $data');
        return {
          'topping': (data['topping'] as List<dynamic>)
              .map<String>((t) => t['keterangan'].toString())
              .toList(),
          'level': (data['level'] as List<dynamic>)
              .map<String>((l) => l['keterangan'].toString())
              .toList(),
        };
      } else {
        throw Exception('Failed to load menu details');
      }
    } catch (e) {
      print("Error fetching menu details for ID $idMenu: $e");
      return {
        'topping': [],
        'level': [],
      };
    }
  }
}
