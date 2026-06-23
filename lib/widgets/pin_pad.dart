import 'package:flutter/material.dart';

class PinPad extends StatelessWidget {
  final Function(String) onNumPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onClearPressed;

  const PinPad({
    super.key,
    required this.onNumPressed,
    required this.onDeletePressed,
    this.onClearPressed,
  });

  Widget _buildButton(
    String text,
    BuildContext context, {
    VoidCallback? customPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          onPressed: customPressed ?? () => onNumPressed(text),
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            side: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // --- FIXED: Dynamically pulls text color matching your layout background ---
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((num) => _buildButton(num, context)).toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                onPressed: onClearPressed ?? () {},
                icon: Icon(
                  onClearPressed != null ? Icons.clear_all : null,
                  // --- FIXED: Ensures the clear icon changes color in dark mode ---
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            _buildButton('0', context),
            Expanded(
              child: IconButton(
                onPressed: onDeletePressed,
                icon: const Icon(
                  Icons.backspace_outlined,
                  color: Colors
                      .redAccent, // Red accent remains readable on both colors
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
