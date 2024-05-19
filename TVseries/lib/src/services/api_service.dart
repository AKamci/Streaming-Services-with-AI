import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ApiDataService {

    Future<void> _fetchProtectedData(String apiPath) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('https://your-api.com/protected'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Veriyi işleme
      } else {
        // Hata durumunu yönet
      }
    }

}



