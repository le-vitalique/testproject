import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testproject/contact.dart';
import 'package:testproject/add_contacts.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key, required this.title});

  final String title;

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: const <BarcodeFormat>[BarcodeFormat.qrCode],
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _foundBarcode,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 100,
              width: 100,
              child: ToggleFlashlightButton(controller: controller),
              // Icon(Icons.flash_on),
            ),
          )
        ],
      ),
    );
  }

  void _foundBarcode(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      late List<Contact> contactList;
      try {
        Iterable contact = jsonDecode(barcode.rawValue.toString());
        contactList =
            List<Contact>.from(contact.map((model) => Contact.fromJson(model)));
      } catch (e) {
        try {
          final contactMap =
              jsonDecode(barcode.rawValue.toString()) as Map<String, dynamic>;
          final Contact contact = Contact.fromJson(contactMap);

          print(contact.phone);
          print(contact.name);
          print(contact.id);
          contactList = [contact];
        } catch (e) {
          return;
        }
      }

      // if code is List<Contact> then show FoundCodeScreen
      controller.stop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddContacts(
            contactList: contactList,
          ),
        ),
      );
      controller.start();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const SizedBox.square(
              dimension: 48.0,
              child: Icon(
                Icons.no_flash,
                size: 32.0,
                color: Colors.grey,
              ),
            );
        }
      },
    );
  }
}
