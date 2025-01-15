import 'package:flutter/material.dart';

import 'package:get/get.dart';

class YourEventView extends GetView {
  const YourEventView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YourEventView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'YourEventView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
