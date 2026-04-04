import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scanner/features/scanner/presentation/widgets/glass_container.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_event.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OCREditPage extends StatefulWidget {
  final File imageFile;
  const OCREditPage({super.key, required this.imageFile});

  @override
  State<OCREditPage> createState() => _OCREditPageState();
}

class _OCREditPageState extends State<OCREditPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ScannerBloc>().add(ScanImageEvent(widget.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Text Preview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () => _saveResult(context),
              child: const Text(
                'Save',
                style: TextStyle(color: AppTheme.primaryIndigo, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocConsumer<ScannerBloc, ScannerState>(
            listener: (context, state) {
              if (state is ScannerResultState) {
                _controller.text = state.text;
              }
              if (state is ScannerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              if (state is ScannerLoading) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.primaryIndigo));
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppTheme.premiumShadow,
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Extracting text...',
                          ),
                          style: const TextStyle(fontSize: 16, height: 1.6, letterSpacing: 0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildFloatingImagePreview(context),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _buildActionBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingImagePreview(BuildContext context) {
    return Positioned(
      top: 10,
      right: 32,
      child: GestureDetector(
        onTap: () => _showFullImage(context),
        child: Hero(
          tag: 'image_preview',
          child: Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: AppTheme.premiumShadow,
              image: DecorationImage(
                image: FileImage(widget.imageFile),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                ),
              ),
              child: const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1);
  }

  void _showFullImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(
            child: Hero(
              tag: 'image_preview',
              child: Image.file(widget.imageFile),
            ),
          ),
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
        const SnackBar(
          content: Text('Saved to history'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.secondaryEmerald,
        ),
      );
    }
  }

  Widget _buildActionBar(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      borderRadius: BorderRadius.circular(40),
      blur: 20,
      opacity: 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            context,
            icon: Icons.copy_all_rounded,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
          _buildActionButton(
            context,
            icon: Icons.ios_share_rounded,
            label: 'Share',
            onTap: () {
              if (_controller.text.isNotEmpty) {
                Share.share(_controller.text);
              }
            },
          ),
          _buildActionButton(
            context,
            icon: Icons.picture_as_pdf_rounded,
            label: 'PDF',
            isPrimary: true,
            onTap: () => _exportToPdf(),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 600.ms);
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: isPrimary ? Colors.white : Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Text(_controller.text, style: const pw.TextStyle(fontSize: 14)),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
