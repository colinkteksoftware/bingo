import 'package:flutter/material.dart';

class GameTypeWidget extends StatelessWidget {
  final int aditional;
  final int counter;
  final Function(int) onTypeSelected;
  final Function() onIncrement;
  final Function() onDecrement;
  final Function(int) onCounterChanged;
  final TextEditingController counterController;

  const GameTypeWidget({
    super.key,
    required this.aditional,
    required this.counter,
    required this.onTypeSelected,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCounterChanged,
    required this.counterController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget buildOption(String label, int value) {
      final isSelected = aditional == value;

      return GestureDetector(
        onTap: () => onTypeSelected(value),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.black,
                  width: 2,
                ),
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              padding: const EdgeInsets.all(12),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : const SizedBox(),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.030,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildOption("Normal", 0),
        const SizedBox(width: 10),
        buildOption("Promocional", 1),
        const SizedBox(width: 10),
        buildOption("Progresivo", 2),
        if (aditional == 2) ...[
          const SizedBox(width: 10),
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 60,
            child: TextFormField(
              controller: counterController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  onCounterChanged(parsed);
                }
              },
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
          ),
        ]
      ],
    );
  }
}