import 'package:flutter/material.dart';

class StepItem extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isCurrent;
  final bool hasLineBefore;
  final bool hasLineAfter;

  const StepItem({
    super.key,
    required this.label,
    this.isCompleted = false,
    this.isCurrent = false,
    this.hasLineBefore = true,
    this.hasLineAfter = true,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xff19B68A);
    const inactiveColor = Colors.white;
    const inactiveBorderColor = Color(0xffE7E8E8);

    return Column(
      children: [
        Row(
          children: [
            // Left line
            if (hasLineBefore)
              Expanded(
                child: Container(
                  height: 2,
                  color: inactiveBorderColor,
                ),
              ),

            // Circle
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? activeColor : inactiveColor,
                border: isCompleted
                    ? null //no border on completed
                    : Border.all(
                        color: isCurrent ? activeColor : inactiveBorderColor,
                        width: 7,
                      ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),

            // Right line
            if (hasLineAfter)
              Expanded(
                child: Container(
                  height: 2,
                  color: inactiveBorderColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isCurrent ? activeColor : Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
