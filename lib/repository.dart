import 'dart:io';

import 'package:dio/dio.dart';

import 'models/error.dart';
import 'models/result.dart';

class DioRepo {
  Dio dio = Dio();

  Future<Result> saveFace(String email, File image) async {
    FormData formData = FormData.fromMap({
      "Images": [await MultipartFile.fromFile(image.path)],
      "EmployeeEmailAddress": email,
    });

    try {
      await dio.post(
        'https://api-biometric-dev.acudir.net/api/face-biometric/face-by-employee-email',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return Result.success();
    } catch (e) {
      if (e is DioException) {
        return Result.failure(ErrorModel.fromJson(e.response!.data));
      } else {
        return Result.failure(
          ErrorModel(
            errors: [
              Error(description: 'Unknown error', type: 500)
            ],
          ),
        );
      }
    }
  }
}
