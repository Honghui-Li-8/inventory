import 'package:flutter/material.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/services/api.dart';

class InventoryDetail extends StatefulWidget {
  final String inventoryId;

  const InventoryDetail({super.key, required this.inventoryId});

  @override
  State<InventoryDetail> createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {
  Future<void> _load() async {
    Inventory inventory = await APIService.instance.getInventory(
      widget.inventoryId,
    );
    print(inventory.items);
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          Text(widget.inventoryId),
        ],
      ),
    );
  }
}
