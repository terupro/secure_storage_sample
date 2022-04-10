import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyPets = 'pets';
  static const _keyBirthday = 'birthday';

  // Nameの保存
  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  // Nameの読み込み
  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUsername);

  // Petsの保存
  static Future setPets(List<String> pets) async {
    final value = json.encode(pets);
    await _storage.write(key: _keyPets, value: value);
  }

  // Petsの読み込み
  static Future<List<String>?> getPets() async {
    final value = await _storage.read(key: _keyPets);
    return value == null ? null : List<String>.from(json.decode(value));
  }

  // Birthdayの保存
  static Future setBirthday(DateTime dateOfBirth) async {
    final birthday = dateOfBirth.toIso8601String();
    await _storage.write(key: _keyBirthday, value: birthday);
  }

  // Birthdayの読み込み
  static Future<DateTime?> getBirthday() async {
    final birthday = await _storage.read(key: _keyBirthday);
    return birthday == null ? null : DateTime.tryParse(birthday);
  }

  // 保存した全データの削除
  static Future deleteAll() async {
    await _storage.deleteAll();
  }
}
