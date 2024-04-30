import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class DioRepo {
  Dio dio = Dio();

  Future<bool> saveFace(String email, File image) async {
    FormData formData = FormData.fromMap({
      // Agrega archivos
      "Images": [
        await MultipartFile.fromFile(image.path)
      ],
      "EmployeeEmailAddress": email,
    });

    try {
      final response = await dio.post(
        'https://api-biometric-dev.acudir.net/api/face-biometric/face-by-employee-email',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        log(e.response!.data.toString());
      }
      return false;
    }
  }
}
