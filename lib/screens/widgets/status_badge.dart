import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Widget Reusable Badge Status Kebersihan atau Laporan
class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12.0,
  });

  Color _getBadgeColor() {
    switch (status.toLowerCase()) {
      case 'baik':
      case 'selesai':
        return AppTheme.statusBaik;
      case 'waspada':
      case 'diproses':
        return AppTheme.statusWaspada;
      case 'bahaya':
      case 'pending':
      default:
        return AppTheme.statusBahaya;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
