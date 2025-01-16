import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:myapp/app/data/detail_event_response.dart';
import 'package:myapp/app/data/event_response.dart';
import 'package:myapp/app/modules/dashboard/views/index_view.dart';
import 'package:myapp/app/modules/dashboard/views/profile_view.dart';
import 'package:myapp/app/modules/dashboard/views/your_event_view.dart';
import 'package:myapp/app/utils/api.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs; // Index tab yang dipilih
  final _getConnect = GetConnect();

  // Controller untuk input form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // List event milik user
  var yourEvents = <Events>[].obs;

  String get token => GetStorage().read('token') ?? '';

  // Fungsi untuk mendapatkan semua event
  Future<EventResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return EventResponse.fromJson(response.body);
  }

  // Fungsi untuk mendapatkan event user
  Future<void> getYourEvent() async {
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);
    yourEvents.value = eventResponse.events ?? [];
  }

  // Fungsi untuk mendapatkan detail event berdasarkan ID
  Future<DetailEventResponse> getDetailEvent({required int id}) async {
    final response = await _getConnect.get(
      '${BaseUrl.detailEvents}/$id',
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return DetailEventResponse.fromJson(response.body);
  }

  // Fungsi untuk menambahkan event baru
  Future<void> addEvent() async {
    final response = await _getConnect.post(
      BaseUrl.events,
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 201) {
      _tampilkanSnackbar('Berhasil', 'Event berhasil ditambahkan', Colors.green);
      _bersihkanForm();
      await refreshEvents();
    } else {
      _tampilkanSnackbar('Gagal', 'Gagal menambahkan event', Colors.red);
    }
  }

  // Fungsi untuk mengedit event
  Future<void> editEvent({required int id}) async {
    final response = await _getConnect.post(
      '${BaseUrl.events}/$id',
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
        '_method': 'PUT',
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 200) {
      _tampilkanSnackbar('Berhasil', 'Event berhasil diubah', Colors.green);
      _bersihkanForm();
      await refreshEvents();
    } else {
      _tampilkanSnackbar('Gagal', 'Gagal mengubah event', Colors.red);
    }
  }

  // Fungsi untuk menghapus event berdasarkan ID
  Future<void> deleteEvent({required int id}) async {
    final response = await _getConnect.post(
      '${BaseUrl.deleteEvents}$id',
      {'_method': 'DELETE'},
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 200) {
      _tampilkanSnackbar('Berhasil', 'Event berhasil dihapus', Colors.green);
      await refreshEvents();
    } else {
      _tampilkanSnackbar('Gagal', 'Gagal menghapus event', Colors.red);
    }
  }

  // Fungsi untuk membersihkan input form
  void _bersihkanForm() {
    nameController.clear();
    descriptionController.clear();
    eventDateController.clear();
    locationController.clear();
  }

  // Fungsi untuk refresh data event
  Future<void> refreshEvents() async {
    await getEvent();
    await getYourEvent();
  }

  // Fungsi untuk menampilkan snackbar
  void _tampilkanSnackbar(String judul, String pesan, Color warnaLatar) {
    Get.snackbar(
      judul,
      pesan,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: warnaLatar,
      colorText: Colors.white,
    );
  }

  // Fungsi untuk mengganti tab yang dipilih
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Daftar halaman untuk bottom navigation
  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    refreshEvents(); // Memuat event saat controller diinisialisasi
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    eventDateController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
