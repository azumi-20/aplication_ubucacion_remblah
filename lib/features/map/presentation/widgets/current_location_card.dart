import 'package:flutter/material.dart';

class CurrentLocationCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onClose;
  final VoidCallback onPressed;

  const CurrentLocationCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onClose,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔹 FILA SUPERIOR
            Row(
              children: [

                const Icon(Icons.place, color: Colors.green),

                const SizedBox(width: 8),

                /// 🔥 ESTO EVITA EL OVERFLOW
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),

                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 BOTÓN VER DETALLE
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
