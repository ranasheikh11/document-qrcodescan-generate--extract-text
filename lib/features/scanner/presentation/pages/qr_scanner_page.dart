import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/core/theme/app_theme.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.all],
  );
  String _mode = 'DOCUMENT';
  bool _isFlashOn = false;

  @override
  void dispose() {
    controller.dispose();
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
              if (_mode == 'QR CODE') {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context, barcodes.first.rawValue);
                }
              }
            },
          ),
          _buildCameraOverlay(),
          _buildTopHeader(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
              ),
              Column(
                children: [
                   Text(
                    _mode == 'DOCUMENT' ? 'DOCUMENT SCAN' : (_mode == 'QR CODE' ? 'QR CODE SCAN' : 'ID CARD SCAN'),
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                      ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.seconds, begin: const Offset(0.7, 0.7), end: const Offset(1.3, 1.3)).fadeIn(),
                      const SizedBox(width: 8),
                      Text(
                        'PRECISION ACTIVE',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraOverlay() {
    final size = MediaQuery.of(context).size;
    final viewWidth = _mode == 'ID CARD' ? size.width * 0.85 : 280.0;
    final viewHeight = _mode == 'ID CARD' ? 220.0 : (_mode == 'DOCUMENT' ? 400.0 : 280.0);

    return Center(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: 400.ms,
            curve: Curves.easeInOutCubic,
            width: viewWidth,
            height: viewHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          ...[
            Positioned(top: 0, left: 0, child: _Corner(quarter: 0)),
            Positioned(top: 0, right: 0, child: _Corner(quarter: 1)),
            Positioned(bottom: 0, left: 0, child: _Corner(quarter: 3)),
            Positioned(bottom: 0, right: 0, child: _Corner(quarter: 2)),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularButton(Icons.photo_library_outlined, 'IMPORT', () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null && mounted) {
                    Navigator.pop(context, image.path);
                  }
                }),
                _buildShutterButton(),
                _buildCircularButton(_isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded, 'TORCH', () {
                  setState(() => _isFlashOn = !_isFlashOn);
                  controller.toggleTorch();
                }),
              ],
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildModeTab('DOCUMENT'),
                  _buildModeTab('ID CARD'),
                  _buildModeTab('QR CODE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab(String mode) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _mode = mode);
      },
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          mode,
          style: GoogleFonts.inter(
            color: isSelected ? AppTheme.primaryNavy : Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _mode == 'QR CODE' ? Icons.qr_code_scanner_rounded : Icons.camera_alt_rounded,
                color: AppTheme.primaryNavy,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final int quarter;
  const _Corner({required this.quarter});

  @override
  Widget build(BuildContext context) {
    const double cornerSize = 40.0;
    const double thickness = 6.0;
    
    return Container(
      width: cornerSize,
      height: cornerSize,
      decoration: BoxDecoration(
        border: Border(
          top: quarter == 0 || quarter == 1 ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
          bottom: quarter == 2 || quarter == 3 ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
          left: quarter == 0 || quarter == 3 ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
          right: quarter == 1 || quarter == 2 ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: quarter == 0 ? const Radius.circular(20) : Radius.zero,
          topRight: quarter == 1 ? const Radius.circular(20) : Radius.zero,
          bottomRight: quarter == 2 ? const Radius.circular(20) : Radius.zero,
          bottomLeft: quarter == 3 ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }
}
