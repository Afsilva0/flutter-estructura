import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:listo/app/domain/entities/login/generico_dto.dart';
import 'package:listo/assets/constantes.dart';

class HttpService {
  final dynamic body;
  final String endPoint;
  final String? token;

  HttpService({required this.body, required this.endPoint, this.token});

//  late GenericoDTO genericDto;

  /* Future<T> load<T>(HttpService<T> resource) async {
    final response = await http.get(resource.url!);
    if (response.statusCode == 200) {
      return resource.parse!(response);
    } else {
      throw Exception(response.statusCode);
    }
  }*/

  Future<Object?> post() async {
    try {
      final _urlAuth = Constantes.urlBase + endPoint;
      final Map<String, String> headers = obtenerCabeceras(token);

      final http.Response respuesta = await http.post(Uri.parse(_urlAuth),
          body: json.encode(body), headers: headers);

      GenericoDTO genericDto =
          GenericoDTO.fromJson(json.decode(respuesta.body));

      if (genericDto.status == 200) {
        return genericDto.payload;
      } else if (genericDto.status == 500) {
        throw Exception(genericDto.payload);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Object?> get() async {
    try {
      final _urlAuth = Constantes.urlBase + endPoint;
      final Map<String, String> headers = obtenerCabeceras(token);

      final http.Response respuesta =
          await http.get(Uri.parse(_urlAuth), headers: headers);

      GenericoDTO genericDto =
          GenericoDTO.fromJson(json.decode(respuesta.body));

      if (genericDto.status == 200) {
        return genericDto.payload;
      } else if (genericDto.status == 500) {
        throw Exception(genericDto.payload);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /* Future<T> put<T>(HttpService<T> resource) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
    };
    final response = await http.put(resource.url!,
        body: jsonEncode(resource.body), headers: headers);
    if (response.statusCode == 200) {
      return resource.parse!(response);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<T> delete<T>(HttpService<T> resource) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
    };
    final response = await http.delete(resource.url!, headers: headers);
    if (response.statusCode == 200) {
      return resource.parse!(response);
    } else {
      throw Exception(response.statusCode);
    }
  }*/

  Map<String, String> obtenerCabeceras(String? token) {
    final Map<String, String> listaCabeceras = <String, String>{};

    listaCabeceras.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json');

    if (token != null && token.isNotEmpty) {
      listaCabeceras.putIfAbsent(
          HttpHeaders.authorizationHeader, () => 'Bearer ' + token);
    }

    return listaCabeceras;
  }
}
