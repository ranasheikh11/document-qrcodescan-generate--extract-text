import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_event.dart';
import 'package:scanner/features/scanner/presentation/widgets/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  late MobileScannerController controller;
  late AnimationController _animationController;
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (isScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? "Unknown";
                setState(() => isScanned = true);
                HapticFeedback.mediumImpact();
                _showResult(context, code);
              }
            },
          ),
          _buildOverlay(context),
          _buildControls(context),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
        Row(
          children: [
            Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              child: Stack(
                children: [
                  _buildCornerBorder(),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: _animationController.value * 240,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryIndigo.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryIndigo.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.black.withOpacity(0.5))),
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20),
            child: const Text('Scan QR or Barcode', style: TextStyle(color: Colors.white70, fontSize: 16)),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildCornerBorder() {
    return CustomPaint(
      size: const Size(250, 250),
      painter: CornerPainter(),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFAB(
            onPressed: () => controller.toggleTorch(),
            icon: Icons.flashlight_on_rounded,
          ),
          _buildFAB(
            onPressed: () => controller.switchCamera(),
            icon: Icons.flip_camera_ios_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB({required VoidCallback onPressed, required IconData icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: GlassContainer(
        width: 64,
        height: 64,
        borderRadius: BorderRadius.circular(24),
        blur: 15,
        opacity: 0.1,
        child: Center(
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String code) {
    context.read<ScannerBloc>().add(SaveScanEvent(text: code, type: 'QR'));
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Icon(Icons.check_circle_rounded, color: AppTheme.secondaryEmerald, size: 48),
            const SizedBox(height: 16),
            const Text('Scan Successful', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: SelectableText(code, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryIndigo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                  },
                  icon: const Icon(Icons.copy_rounded, color: AppTheme.primaryIndigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryIndigo
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;

    // Top Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
