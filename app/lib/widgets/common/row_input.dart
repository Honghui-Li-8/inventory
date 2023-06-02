import 'package:flutter/material.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/widgets/common/counter.dart';

class InventoryRowInput extends StatelessWidget {
  final int id;
  final Item? item;
  final bool isEmpty;
  final void Function(int id, Item nItem) onChange;
  final void Function(int id) onDelete;
  final void Function(Item item)? create;

  final TextEditingController textEditingController = TextEditingController();

  InventoryRowInput(
      {super.key,
      required this.id,
      required this.item,
      required this.onChange,
      required this.onDelete,
      this.isEmpty = false,
      this.create});

  void updateItem() {
    if (isEmpty) {
      create!(
        Item(
          name: textEditingController.text,
          quantity: 1,
          tags: [],
        ),
      );
      return;
    }
    Item nItem = Item(
      name: textEditingController.text,
      quantity: item!.quantity,
      tags: item!.tags,
    );
    onChange(id, nItem);
  }

  void updateItemQuantity(int quantity) {
    if (isEmpty) {
      create!(
        const Item(
          name: "New Item",
          quantity: 1,
          tags: [],
        ),
      );
      return;
    }
    Item nItem = Item(
      name: item!.name,
      quantity: quantity,
      tags: item!.tags,
    );
    onChange(id, nItem);
  }

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) {
      textEditingController.text = item!.name;
    }
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Focus(
            onFocusChange: (value) {
              if (!value) {
                updateItem();
              }
            },
            child: TextField(
              controller: textEditingController,
              onEditingComplete: updateItem,
              decoration: const InputDecoration(
                hintText: '   Enter Item',
              ),
            ),
          ),
        ),
        Expanded(child: Container()),
        Counter(
            value: item == null ? 0 : item!.quantity,
            onChanged: updateItemQuantity),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: item == null
              ? null
              : () {
                  onDelete(id);
                },
        ),
      ],
    );
  }
}
