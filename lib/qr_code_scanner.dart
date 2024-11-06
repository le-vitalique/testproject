import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testproject/contact.dart';
import 'package:testproject/add_contacts.dart';
import 'package:testproject/contact_list.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

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
      appBar: AppBar(
        title: const Text('Сканер'),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactList(),
                  ),
                );
              },
              icon: const Icon(Icons.contacts))
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _foundBarcode,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ToggleFlashlightButton(controller: controller),
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
          contactList = [contact];
        } catch (e) {
          return;
        }
      }

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
            return ElevatedButton(
              onPressed: () async {
                await controller.toggleTorch();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.flash_auto),
            );
          case TorchState.off:
            return ElevatedButton(
              onPressed: () async {
                await controller.toggleTorch();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.flash_off),
            );
          case TorchState.on:
            return ElevatedButton(
              onPressed: () async {
                await controller.toggleTorch();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.flash_on),
            );
          case TorchState.unavailable:
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.no_flash),
            );
        }
      },
    );
  }
}
