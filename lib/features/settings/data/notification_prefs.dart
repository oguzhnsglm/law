import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Hatırlatma tercihleri — onboarding/settings'ten yönetilir.
class NotificationPrefs extends Equatable {
  const NotificationPrefs({
    this.notificationsEnabled = true,
    this.oneDayBefore = true,
    this.oneDayBeforeHour = 21,
    this.twoHoursBefore = true,
  });

  final bool notificationsEnabled;
  final bool oneDayBefore;

  /// 0-23 arası, "1 gün önce" hatırlatmasının saati.
  final int oneDayBeforeHour;

  final bool twoHoursBefore;

  NotificationPrefs copyWith({
    bool? notificationsEnabled,
    bool? oneDayBefore,
    int? oneDayBeforeHour,
    bool? twoHoursBefore,
  }) {
    return NotificationPrefs(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      oneDayBefore: oneDayBefore ?? this.oneDayBefore,
      oneDayBeforeHour: oneDayBeforeHour ?? this.oneDayBeforeHour,
      twoHoursBefore: twoHoursBefore ?? this.twoHoursBefore,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'notificationsEnabled': notificationsEnabled,
        'oneDayBefore': oneDayBefore,
        'oneDayBeforeHour': oneDayBeforeHour,
        'twoHoursBefore': twoHoursBefore,
      };

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) {
    return NotificationPrefs(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      oneDayBefore: json['oneDayBefore'] as bool? ?? true,
      oneDayBeforeHour: json['oneDayBeforeHour'] as int? ?? 21,
      twoHoursBefore: json['twoHoursBefore'] as bool? ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory NotificationPrefs.fromJsonString(String s) =>
      NotificationPrefs.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        notificationsEnabled,
        oneDayBefore,
        oneDayBeforeHour,
        twoHoursBefore,
      ];
}
