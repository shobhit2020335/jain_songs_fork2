import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:permission_client/permission_client.dart';

/// {@template notifications_failure}
/// A base failure for the notifications repository failures.
/// {@endtemplate}
abstract class NotificationsFailure with EquatableMixin implements Exception {
  /// {@macro notifications_failure}
  const NotificationsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template initialize_categories_preferences_failure}
/// Thrown when initializing categories preferences fails.
/// {@endtemplate}
class InitializeCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro initialize_categories_preferences_failure}
  const InitializeCategoriesPreferencesFailure(super.error);
}

/// {@template toggle_notifications_failure}
/// Thrown when toggling notifications fails.
/// {@endtemplate}
class ToggleNotificationsFailure extends NotificationsFailure {
  /// {@macro toggle_notifications_failure}
  const ToggleNotificationsFailure(super.error);
}

/// {@template fetch_notifications_enabled_failure}
/// Thrown when fetching a notifications enabled status fails.
/// {@endtemplate}
class FetchNotificationsEnabledFailure extends NotificationsFailure {
  /// {@macro fetch_notifications_enabled_failure}
  const FetchNotificationsEnabledFailure(super.error);
}

/// {@template set_categories_preferences_failure}
/// Thrown when setting categories preferences fails.
/// {@endtemplate}
class SetCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro set_categories_preferences_failure}
  const SetCategoriesPreferencesFailure(super.error);
}

/// {@template fetch_categories_preferences_failure}
/// Thrown when fetching categories preferences fails.
/// {@endtemplate}
class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro fetch_categories_preferences_failure}
  const FetchCategoriesPreferencesFailure(super.error);
}

/// {@template notifications_repository}
/// A repository that manages notification permissions and topic subscriptions.
///
/// Access to the device's notifications can be toggled with
/// [toggleNotifications] and checked with [fetchNotificationsEnabled].
///
/// Notification preferences for topic subscriptions related to news categories
/// may be updated with [setCategoriesPreferences] and checked with
/// [fetchCategoriesPreferences].
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  NotificationsRepository({
    required PermissionClient permissionClient,
  }) : _permissionClient = permissionClient;

  final PermissionClient _permissionClient;

  /// Toggles the notifications based on the [enable].
  ///
  /// When [enable] is true, request the notification permission if not granted
  /// and marks the notification setting as enabled. Subscribes the user to
  /// notifications related to user's categories preferences.
  ///
  /// When [enable] is false, marks notification setting as disabled and
  /// unsubscribes the user from notifications related to user's categories
  /// preferences.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      // Request the notification permission when turning notifications on.
      if (enable) {
        // Find the current notification permission status.
        final permissionStatus = await _permissionClient.notificationsStatus();

        // Navigate the user to permission settings
        // if the permission status is permanently denied or restricted.
        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        // Request the permission if the permission status is denied.
        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  /// Returns true when the notification permission is granted
  /// and the notification setting is enabled.
  Future<bool> fetchNotificationsEnabled() async {
    try {
      final results = await Future.wait([
        _permissionClient.notificationsStatus(),
      ]);

      final permissionStatus = results.first as PermissionStatus;
      final notificationsEnabled = results.last as bool;

      return permissionStatus.isGranted && notificationsEnabled;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchNotificationsEnabledFailure(error),
        stackTrace,
      );
    }
  }
}
