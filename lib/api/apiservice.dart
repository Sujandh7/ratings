

import 'package:firebase/api/api_response.dart';
import 'package:firebase/model/credential.dart';

abstract class ApiService{
  Future<ApiResponse> saveStudent(Credential credential) ;
  //Future<ApiResponse> getStudent();
  Future<ApiResponse> loginData(Credential credential) ;
  Future<Map<String, dynamic>> getUserData(String uid);

}