import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_state.dart';
import 'package:scanner/features/scanner/presentation/pages/ocr_edit_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_scanner_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_generator_page.dart';
import 'package:scanner/features/scanner/presentation/widgets/home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildHeroSection(),
            _buildQuickActions(),
            _buildRecentActivityHeader(),
            _buildRecentActivityList(),
            const SizedBox(height: 120), // Padding for floating nav
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.dashboard_rounded, color: AppTheme.primaryNavy, size: 28),
            const SizedBox(width: 16),
            Text(
              'ArchivePro',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppTheme.primaryNavy,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryNavy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryNavy, Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.tertiaryAmber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PREMIUM ARCHIVIST',
              style: GoogleFonts.inter(
                color: AppTheme.tertiaryAmber,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Institutional Grade\nTranscription.',
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Securely scan and organize your critical documents with AI-powered precision.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildModernButton(
                'NEW SCAN',
                Icons.document_scanner_rounded,
                Colors.white,
                AppTheme.primaryNavy,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerPage()),
                ),
              ),
              const SizedBox(width: 12),
              _buildModernButton(
                'IMPORT',
                Icons.file_upload_outlined,
                Colors.white.withOpacity(0.1),
                Colors.white,
                () => _pickImage(context, ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildModernButton(String label, IconData icon, Color bg, Color text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: text),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: text,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Capabilities',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppTheme.primaryNavy,
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: AppTheme.primaryNavy),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: PremiumMenuCard(
                  title: 'OCR Tool',
                  subtitle: 'Text extraction',
                  icon: Icons.auto_fix_high_rounded,
                  color: const Color(0xFF6366F1),
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PremiumMenuCard(
                  title: 'QR Code',
                  subtitle: 'Generator',
                  icon: Icons.qr_code_2_rounded,
                  color: const Color(0xFFF59E0B),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QRGeneratorPage()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildVaultStatus(),
        ],
      ),
    );
  }

  Widget _buildVaultStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security_rounded, color: AppTheme.primaryNavy),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vault 7-Day Retention',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.primaryNavy,
                  ),
                ),
                Text(
                  'Auto-pruning active for security.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ACTIVE',
              style: GoogleFonts.inter(
                color: const Color(0xFF10B981),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Documents',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppTheme.primaryNavy,
            ),
          ),
          Text(
            'VIEW ALL',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryNavy,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return BlocBuilder<ScannerBloc, ScannerState>(
      builder: (context, state) {
        if (state is HistoryLoadedState && state.history.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.history.length > 3 ? 3 : state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              return _buildActivityItem(item);
            },
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'No recent activities. Start scanning to see them here.',
            style: GoogleFonts.inter(color: AppTheme.onSurfaceVariant),
          ),
        );
      },
    );
  }

  Widget _buildActivityItem(dynamic item) {
    final isOcr = item.type == 'OCR';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOcr ? Icons.description : Icons.qr_code_2,
              color: AppTheme.primaryNavy,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fileName ?? 'Unnamed Document',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppTheme.primaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOcr ? Colors.green : AppTheme.primaryNavy,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOcr ? 'OCR' : 'QR GEN',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'OCT 24, 11:30 AM',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD5E0F7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'Verified'.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF586377),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert, color: AppTheme.onSurfaceVariant),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Document',
            toolbarColor: AppTheme.primaryNavy,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Document'),
        ],
      );

      if (croppedFile != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OCREditPage(imageFile: File(croppedFile.path)),
          ),
        );
      }
    }
  }
}
