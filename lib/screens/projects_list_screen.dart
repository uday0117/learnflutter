import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/projects_data.dart';
import '../models/project_model.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import 'project_detail_screen.dart';

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  bool _isUnlocked(String projectId) {
    if (AdService().isAdFree) return true;
    final allExpiry = GetStorage().read<int>('all_projects_unlocked_expiry');
    if (allExpiry != null && DateTime.now().millisecondsSinceEpoch < allExpiry) {
      return true;
    }
    final expiry = GetStorage().read<int>('project_unlocked_$projectId');
    if (expiry != null && DateTime.now().millisecondsSinceEpoch < expiry) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreenView('ProjectsListScreen');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projects = ProjectsData.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Project Code', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(context, project, isDark);
          },
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project, bool isDark) {
    final unlocked = _isUnlocked(project.id);
    final isFirebase = project.id.contains('firebase');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Get.to(
          () => ProjectDetailScreen(project: project),
          transition: Transition.rightToLeft,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row (Name + Difficulty & Firebase Badges) ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isFirebase) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cloud_sync_rounded, color: Colors.amber, size: 13),
                                SizedBox(width: 4),
                                Text(
                                  'Firebase Backend',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildDifficultyBadge(project.difficulty),
                ],
              ),
              const SizedBox(height: 8),

              // ── Description ──
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, height: 1.4, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // ── Quick Info Features/Libs row ──
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.checklist_rounded, size: 18, color: Colors.blue.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${project.features.length} Features',
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.library_books_rounded, size: 18, color: Colors.purple.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${project.libraries.length} Libraries',
                        style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),

              // ── Bottom trigger action row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        unlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                        color: unlocked ? Colors.green : Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unlocked ? 'Unlocked & Ready' : 'Rewarded Ad Pass',
                        style: TextStyle(
                          color: unlocked ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View Blueprint',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: Colors.blue.shade600, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'Beginner':
        color = Colors.green;
        break;
      case 'Intermediate':
        color = Colors.orange;
        break;
      case 'Advanced':
      default:
        color = Colors.red;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        difficulty,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
