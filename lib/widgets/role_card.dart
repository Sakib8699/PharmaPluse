import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE1F5EE) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF0F6E56) : Colors.grey.shade300,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.green.shade50,
                blurRadius: 12,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: selected ? const Color(0xFF0F6E56) : Colors.grey.shade600,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF0F6E56)
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
