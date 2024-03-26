import 'package:firebase/api/status_util.dart';

class ApiResponse{
  dynamic data;
  NetworkStatus? networkStatus;
  String? errormessage;
  ApiResponse({this.data,this.errormessage,this.networkStatus});
}