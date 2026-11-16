import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UpdateUiPhase {
  hidden,
  checking,
  downloading,
  readyToInstall,
  installing,
  failed,
}

class UpdateController extends GetxController {
  final phase = UpdateUiPhase.hidden.obs;
  final progress = 0.0.obs;
  final statusMessage = ''.obs;
  final appVersion = ''.obs;

  UpdateController({PackageInfo? packageInfo}) {
    if (packageInfo != null) {
      _applyPackageInfo(packageInfo);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (appVersion.value.isEmpty) {
      _loadAppVersion();
    }
  }

  void _applyPackageInfo(PackageInfo info) {
    final v = info.version;
    final b = info.buildNumber.isNotEmpty ? '+${info.buildNumber}' : '';
    if (v.isNotEmpty) {
      appVersion.value = '$v$b';
    }
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _applyPackageInfo(info);
    } catch (_) {
      // Fallback when platform channels unavailable (e.g. headless tests)
      if (appVersion.value.isEmpty) {
        appVersion.value = '';
      }
    }
  }

  bool get isVisible =>
      phase.value != UpdateUiPhase.hidden &&
      phase.value != UpdateUiPhase.checking &&
      phase.value != UpdateUiPhase.failed;

  void showChecking() {
    phase.value = UpdateUiPhase.checking;
    progress.value = 0;
  }

  void showDownloading({double value = 0}) {
    phase.value = UpdateUiPhase.downloading;
    progress.value = value.clamp(0, 1);
    statusMessage.value = 'update_downloading'.tr;
  }

  void showReadyToInstall() {
    phase.value = UpdateUiPhase.readyToInstall;
    progress.value = 1;
    statusMessage.value = 'update_ready'.tr;
  }

  void showInstalling() {
    phase.value = UpdateUiPhase.installing;
    progress.value = 1;
    statusMessage.value = 'update_installing'.tr;
  }

  void hide() {
    phase.value = UpdateUiPhase.hidden;
    progress.value = 0;
    statusMessage.value = '';
  }

  void markFailed() {
    phase.value = UpdateUiPhase.failed;
    progress.value = 0;
  }

  void applyInstallStatus(InstallStatus status) {
    switch (status) {
      case InstallStatus.pending:
        showDownloading(value: 0.05);
      case InstallStatus.downloading:
        showDownloading();
      case InstallStatus.downloaded:
        showReadyToInstall();
      case InstallStatus.installing:
        showInstalling();
      case InstallStatus.installed:
        hide();
      case InstallStatus.canceled:
      case InstallStatus.failed:
      case InstallStatus.unknown:
        markFailed();
        Future.delayed(const Duration(seconds: 2), hide);
    }
  }
}
