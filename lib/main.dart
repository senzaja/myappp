import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // Tambahkan 'async' pada fungsi main
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter binding telah diinisialisasi
  await GetStorage.init(); // Inisialisasi GetStorage
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
