class PinSecurityState {
  const PinSecurityState({
    required this.failedAttempts,
    required this.lockoutLevel,
    this.lockedUntil,
  });

  const PinSecurityState.initial()
      : failedAttempts = 0,
        lockoutLevel = 0,
        lockedUntil = null;

  final int failedAttempts;
  final int lockoutLevel;
  final DateTime? lockedUntil;

  bool get isLocked =>
      lockedUntil != null && lockedUntil!.isAfter(DateTime.now());

  Duration get remainingLockDuration {
    final until = lockedUntil;
    if (until == null) {
      return Duration.zero;
    }
    final remaining = until.difference(DateTime.now());
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  PinSecurityState copyWith({
    int? failedAttempts,
    int? lockoutLevel,
    DateTime? lockedUntil,
    bool clearLockedUntil = false,
  }) {
    return PinSecurityState(
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutLevel: lockoutLevel ?? this.lockoutLevel,
      lockedUntil: clearLockedUntil ? null : (lockedUntil ?? this.lockedUntil),
    );
  }

  Map<String, dynamic> toJson() => {
        'failedAttempts': failedAttempts,
        'lockoutLevel': lockoutLevel,
        'lockedUntil': lockedUntil?.toIso8601String(),
      };

  factory PinSecurityState.fromJson(Map<String, dynamic> json) {
    final rawLockedUntil = json['lockedUntil'] as String?;
    return PinSecurityState(
      failedAttempts: (json['failedAttempts'] as num?)?.toInt() ?? 0,
      lockoutLevel: (json['lockoutLevel'] as num?)?.toInt() ?? 0,
      lockedUntil:
          rawLockedUntil == null ? null : DateTime.tryParse(rawLockedUntil),
    );
  }
}

enum PinVerificationStatus { success, invalidPin, locked }

class PinVerificationResult {
  const PinVerificationResult({
    required this.status,
    required this.securityState,
  });

  final PinVerificationStatus status;
  final PinSecurityState securityState;

  bool get isSuccess => status == PinVerificationStatus.success;
  bool get isLocked => status == PinVerificationStatus.locked;
}
