import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:scanner/core/theme/app_theme.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_bloc.dart';
import 'package:scanner/features/scanner/presentation/bloc/scanner_state.dart';
import 'package:scanner/features/scanner/presentation/pages/ocr_edit_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_scanner_page.dart';
import 'package:scanner/features/scanner/presentation/pages/qr_generator_page.dart';
import 'package:scanner/features/scanner/presentation/widgets/glass_container.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Background Gradient Blob for visual interest
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryIndigo.withOpacity(0.08),
              ),
            ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut).fadeIn(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildSearchBar(context),
                  const SizedBox(height: 40),
                  _buildGridMenu(context),
                  const SizedBox(height: 48),
                  _buildActivityHeader(context),
                  const SizedBox(height: 16),
                  _buildFilterChips(context),
                  const SizedBox(height: 24),
                  _buildRecentActivity(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(20),
      opacity: 0.03,
      blur: 15,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search scans...',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: AppTheme.primaryIndigo.withOpacity(0.7)),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildActivityHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('See All', style: TextStyle(color: AppTheme.primaryIndigo)),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildFilterChips(BuildContext context) {
    final chips = ['All', 'DOCS', 'QR'];
    return Row(
      children: chips.map((label) {
        final isSelected = _filter == label;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _filter = label),
            child: AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryIndigo : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 900.ms);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, Pro',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryEmerald.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      color: AppTheme.secondaryEmerald,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your digital workspace is ready',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
        _buildProfileAvatar(context),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1);
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppTheme.primaryIndigo, AppTheme.primaryIndigo.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMenuCard(
          context,
          'Scan Doc',
          Icons.camera_alt_outlined,
          AppTheme.primaryIndigo,
          () => _pickImage(context, ImageSource.camera),
        ),
        _buildMenuCard(
          context,
          'Pick Image',
          Icons.photo_library_outlined,
          AppTheme.secondaryEmerald,
          () => _pickImage(context, ImageSource.gallery),
        ),
        _buildMenuCard(
          context,
          'QR Scanner',
          Icons.qr_code_scanner_rounded,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRScannerPage()),
          ),
        ),
        _buildMenuCard(
          context,
          'Create QR',
          Icons.add_box_outlined,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRGeneratorPage()),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.premiumShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.05),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(icon, color: color, size: 30),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      builder: (context, state) {
        if (state is HistoryLoadedState && state.history.isNotEmpty) {
          final filteredHistory = state.history.where((item) {
            if (_filter == 'All') return true;
            if (_filter == 'DOCS') return item.type == 'OCR';
            if (_filter == 'QR') return item.type == 'QR';
            return true;
          }).toList();

          if (filteredHistory.isEmpty) {
            return _buildEmptyState(context, 'No results for this filter');
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredHistory.length > 5 ? 5 : filteredHistory.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = filteredHistory[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.premiumShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.type == 'QR'
                            ? Colors.orange.withOpacity(0.1)
                            : AppTheme.primaryIndigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item.type == 'QR' ? Icons.qr_code_2_rounded : Icons.description_outlined,
                        color: item.type == 'QR' ? Colors.orange : AppTheme.primaryIndigo,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM, yyyy • HH:mm').format(item.dateTime),
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey[300]),
                  ],
                ),
              ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
            },
          );
        }
        return _buildEmptyState(context, 'No recent activity');
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[500])),
        ],
      ).animate().fadeIn(),
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
            toolbarColor: AppTheme.primaryIndigo,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
          IOSUiSettings(
            title: 'Crop Document',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
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
