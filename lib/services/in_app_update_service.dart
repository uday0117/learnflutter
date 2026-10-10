import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import '../controllers/update_controller.dart';
import '../utils/url_launcher_helper.dart';
import 'analytics_service.dart';

class InAppUpdateService {
  static final InAppUpdateService _instance = InAppUpdateService._internal();
  factory InAppUpdateService() => _instance;
  InAppUpdateService._internal();

  StreamSubscription<InstallStatus>? _installSubscription;
  Timer? _progressTimer;
  bool _isChecking = false;
  bool _flexibleUpdateStarted = false;

  UpdateController get _controller => Get.find<UpdateController>();

  Future<void> initialize() async {
    if (!_isSupported) return;
    _listenToInstallStatus();
    await checkForUpdate(autoStart: true);
  }

  Future<void> onAppResumed() async {
    if (!_isSupported || _isChecking) return;
    await checkForUpdate(autoStart: true);
  }

  /// Manually checks for updates with complete user feedback (dialogs/snackbars).
  Future<void> checkManually({BuildContext? context}) async {
    if (_isChecking) return;

    Get.snackbar(
      'checking_updates'.tr,
      'checking_updates_sub'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    if (!Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _showUpToDateDialog('1.0.7');
      });
      return;
    }

    _isChecking = true;
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        _handleInProgressUpdate(info.installStatus, autoStart: true);
        return;
      }

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        AnalyticsService().logEvent('manual_update_found', parameters: {
          'flexible': info.flexibleUpdateAllowed.toString(),
          'immediate': info.immediateUpdateAllowed.toString(),
        });

        if (info.flexibleUpdateAllowed) {
          await _startFlexibleUpdate();
        } else if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else {
          _showUpdateAvailableDialog();
        }
      } else {
        _showUpToDateDialog('1.0.7');
      }
    } catch (e, stack) {
      debugPrint('[InAppUpdate] manual check error: $e');
      AnalyticsService().recordError(e, stack, reason: 'Manual update check');
      _showStoreFallbackDialog();
    } finally {
      _isChecking = false;
    }
  }

  void _showUpToDateDialog(String version) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'app_up_to_date_title'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'app_up_to_date_msg'.trParams({'version': version}),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(),
                  child: Text('ok'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStoreFallbackDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store_rounded,
                  color: Colors.blue,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'google_play_updates'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'google_play_updates_msg'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('close'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Get.back();
                        UrlLauncherHelper.openPlayStore();
                      },
                      child: Text('view_on_store'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateAvailableDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.system_update_rounded,
                  color: Colors.orange,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'update_available'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'new_version_available_msg'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Get.back();
                    UrlLauncherHelper.openPlayStore();
                  },
                  child: Text('update_now'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkForUpdate({required bool autoStart}) async {
    if (!_isSupported || _isChecking) return;

    _isChecking = true;
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        _handleInProgressUpdate(info.installStatus, autoStart: autoStart);
        return;
      }

      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      AnalyticsService().logEvent('app_update_available', parameters: {
        'flexible': info.flexibleUpdateAllowed.toString(),
        'immediate': info.immediateUpdateAllowed.toString(),
        'priority': info.updatePriority.toString(),
      });

      if (!autoStart) return;

      if (info.flexibleUpdateAllowed) {
        await _startFlexibleUpdate();
      } else if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e, stack) {
      debugPrint('[InAppUpdate] check failed: $e');
      AnalyticsService().recordError(e, stack, reason: 'In-app update check');
    } finally {
      _isChecking = false;
    }
  }

  void _handleInProgressUpdate(
    InstallStatus status, {
    required bool autoStart,
  }) {
    _controller.applyInstallStatus(status);

    if (status == InstallStatus.downloaded && autoStart) {
      _completeUpdate();
    } else if (status == InstallStatus.downloading ||
        status == InstallStatus.pending) {
      _startProgressSimulation();
    }
  }

  Future<void> _startFlexibleUpdate() async {
    if (_flexibleUpdateStarted) return;

    try {
      _controller.showDownloading(value: 0.02);
      final result = await InAppUpdate.startFlexibleUpdate();

      if (result == AppUpdateResult.success) {
        _flexibleUpdateStarted = true;
        _startProgressSimulation();
        AnalyticsService().logEvent('app_update_download_started');
        return;
      }

      _controller.hide();
    } catch (e, stack) {
      debugPrint('[InAppUpdate] flexible update failed: $e');
      AnalyticsService().recordError(e, stack, reason: 'Flexible update start');
      _controller.markFailed();
      Future.delayed(const Duration(seconds: 2), _controller.hide);
    }
  }

  void _listenToInstallStatus() {
    _installSubscription?.cancel();
    _installSubscription = InAppUpdate.installUpdateListener.listen(
      (status) {
        debugPrint('[InAppUpdate] install status: $status');
        _controller.applyInstallStatus(status);

        switch (status) {
          case InstallStatus.downloading:
          case InstallStatus.pending:
            _startProgressSimulation();
          case InstallStatus.downloaded:
            _stopProgressSimulation();
            _controller.progress.value = 1;
            _completeUpdate();
          case InstallStatus.installing:
            _stopProgressSimulation();
          case InstallStatus.installed:
            _flexibleUpdateStarted = false;
            _stopProgressSimulation();
            _controller.hide();
          case InstallStatus.canceled:
          case InstallStatus.failed:
            _flexibleUpdateStarted = false;
            _stopProgressSimulation();
            _controller.markFailed();
            Future.delayed(const Duration(seconds: 2), _controller.hide);
          case InstallStatus.unknown:
            break;
        }
      },
      onError: (Object error) {
        debugPrint('[InAppUpdate] listener error: $error');
      },
    );
  }

  void _startProgressSimulation() {
    if (_progressTimer?.isActive ?? false) return;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (_controller.phase.value != UpdateUiPhase.downloading) {
        _stopProgressSimulation();
        return;
      }

      final next = _controller.progress.value + 0.03;
      _controller.progress.value = next >= 0.92 ? 0.92 : next;
    });
  }

  void _stopProgressSimulation() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  Future<void> _completeUpdate() async {
    if (!_isSupported) return;

    _controller.showInstalling();
    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      AnalyticsService().logEvent('app_update_installing');
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e, stack) {
      debugPrint('[InAppUpdate] complete failed: $e');
      AnalyticsService().recordError(e, stack, reason: 'Complete flexible update');
      _controller.markFailed();
      Future.delayed(const Duration(seconds: 2), _controller.hide);
    }
  }

  bool get _isSupported => Platform.isAndroid && !kIsWeb && !kDebugMode;

  void dispose() {
    _installSubscription?.cancel();
    _stopProgressSimulation();
  }
}
