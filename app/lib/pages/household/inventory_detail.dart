import 'package:flutter/material.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/pages/household/recipe_generation.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/common/row_input.dart';

class InventoryDetail extends StatefulWidget {
  final String inventoryId;

  const InventoryDetail({super.key, required this.inventoryId});

  @override
  State<InventoryDetail> createState() => _InventoryDetailState();
}

class _InventoryDetailState extends State<InventoryDetail> {
  bool _isLoading = true;
  List<Item> items = [];

  void removeRow(int id) {
    setState(() {
      items.removeAt(id);
    });
  }

  Future<void> _loadItems() async {
    Inventory inventory = await APIService.instance.getInventory(
      widget.inventoryId,
    );
    setState(() {
      items = inventory.items;
      _isLoading = false;
    });
  }

  void addItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  void onSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitScreen(
          future: APIService.instance.syncInventory(widget.inventoryId, items),
          onSuccess: (_) {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );

    APIService.instance.syncInventory(widget.inventoryId, items);
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipePage(
                    inventory: items,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length + 1,
                        itemBuilder: (context, idx) => idx != items.length
                            ? InventoryRowInput(
                                id: idx,
                                item: items[idx],
                                onChange: (int idx, Item nItem) {
                                  setState(() {
                                    items[idx] = nItem;
                                  });
                                },
                                onDelete: removeRow,
                              )
                            : InventoryRowInput(
                                id: idx,
                                item: null,
                                onChange: (_, __) {},
                                onDelete: (_) {},
                                isEmpty: true,
                                create: addItem,
                              ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onSubmit,
                      child: const Text("Confirm"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
