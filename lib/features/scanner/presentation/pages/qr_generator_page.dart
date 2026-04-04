import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:scanner/features/scanner/presentation/widgets/glass_container.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Create QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            _buildInputSection(context),
            const SizedBox(height: 40),
            _buildQRCard(context),
            const SizedBox(height: 48),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Input Content',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.5),
        ),
        const SizedBox(height: 12),
        GlassContainer(
          borderRadius: BorderRadius.circular(24),
          opacity: 0.03,
          blur: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _controller,
            onChanged: (val) => setState(() {}),
            maxLines: 3,
            minLines: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter text or URL to encode...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              prefixIcon: Icon(Icons.link_rounded, color: AppTheme.primaryIndigo),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildQRCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppTheme.premiumShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.primaryIndigo,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: const Center(
                child: Text(
                  'DIGITAL QR CARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: QrImageView(
                data: _controller.text.isEmpty ? " " : _controller.text,
                version: QrVersions.auto,
                size: 180.0,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: Color(0xFF1E293B),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.circle,
                  color: AppTheme.primaryIndigo,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _controller.text.isEmpty ? 'Waiting for input...' : _controller.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            context,
            icon: Icons.copy_rounded,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard'), behavior: SnackBarBehavior.floating),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPrimaryButton(
            context,
            icon: Icons.share_rounded,
            label: 'Share',
            onTap: () {
              if (_controller.text.isNotEmpty) {
                Share.share(_controller.text);
              }
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildPrimaryButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryIndigo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        foregroundColor: Colors.grey[700],
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
