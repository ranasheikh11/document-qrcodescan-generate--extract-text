import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_event.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_generator_page.dart';

class OCREditPage extends StatefulWidget {
  final File imageFile;
  const OCREditPage({super.key, required this.imageFile});

  @override
  State<OCREditPage> createState() => _OCREditPageState();
}

class _OCREditPageState extends State<OCREditPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isRefining = true;

  @override
  void initState() {
    super.initState();
    context.read<ScannerBloc>().add(ScanImageEvent(widget.imageFile));
    // Simulate refining animation for premium feel
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isRefining = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildOCRHeader(context),
            Expanded(
              child: BlocConsumer<ScannerBloc, ScannerState>(
                listener: (context, state) {
                  if (state is ScannerResultState) {
                    _controller.text = state.text;
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildAnalysisSection(),
                        const SizedBox(height: 32),
                        _buildActionCards(context),
                        const SizedBox(height: 32),
                        _buildEditableResult(context),
                        const SizedBox(height: 32),
                        _buildPrimaryActions(context),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOCRHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.description, color: AppTheme.primaryNavy, size: 28),
          const SizedBox(width: 16),
          Text(
            'OCR Extraction',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppTheme.primaryNavy,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppTheme.primaryNavy, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OCR ANALYSIS',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryNavy,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isRefining ? 'Refining Text...' : 'Analysis Complete',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryNavy,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              _isRefining ? '92%' : '100%',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _isRefining ? 0.92 : 1.0,
            backgroundColor: AppTheme.surfaceLow,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryNavy),
            minHeight: 8,
          ),
        ).animate(onPlay: (controller) => _isRefining ? controller.repeat() : null).shimmer(duration: 2.seconds),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildActionCards(BuildContext context) {
    return Row(
      children: [
        _buildActionCard(
          'PREVIEW',
          Icons.visibility_outlined,
          AppTheme.primaryNavy,
          () => _showFullImage(context),
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          'COPY',
          Icons.copy_rounded,
          AppTheme.primaryNavy,
          () {
            Clipboard.setData(ClipboardData(text: _controller.text));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Copied to clipboard'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.primaryNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          'SHARE',
          Icons.share_rounded,
          AppTheme.primaryNavy,
          () => Share.share(_controller.text),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.premiumShadow,
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableResult(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryNavy,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'EDITABLE RESULT',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _controller,
              maxLines: 8,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: AppTheme.primaryNavy,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Processing text...',
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.tertiaryAmber,
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).scale(
                      duration: 1.seconds,
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                    ).fadeIn(duration: 1.seconds),
                const SizedBox(width: 8),
                Text(
                  'AUTO-SAVING',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildPrimaryActions(BuildContext context) {
    return Column(
      children: [
        _buildLargeButton(
          'Save to History',
          Icons.save_rounded,
          AppTheme.primaryNavy,
          () => _saveResult(context),
        ),
        const SizedBox(height: 16),
        _buildLargeButton(
          'Convert to QR',
          Icons.qr_code_2_rounded,
          AppTheme.surfaceLow,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRGeneratorPage(initialText: _controller.text),
              ),
            );
          },
          textColor: AppTheme.primaryNavy,
          iconColor: AppTheme.primaryNavy,
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildLargeButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    Color textColor = Colors.white,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: color == AppTheme.primaryNavy ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? textColor, size: 22),
            const SizedBox(width: 12),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(child: Image.file(widget.imageFile)),
        ),
      ),
    );
  }

  void _saveResult(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<ScannerBloc>().add(SaveScanEvent(
            text: _controller.text,
            type: 'OCR',
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Saved to your vault',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.primaryNavy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
