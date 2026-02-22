class PaymentRequestModel {
  final String bookingId;
  final String currency;

  const PaymentRequestModel({
    required this.bookingId,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'currency': currency,
    };
  }
}

class PaymentResponseModel {
  final String? checkoutUrl;
  final String? message;
  final Map<String, dynamic> raw;

  const PaymentResponseModel({
    required this.raw,
    this.checkoutUrl,
    this.message,
  });

  bool get hasCheckoutUrl => checkoutUrl != null && checkoutUrl!.isNotEmpty;

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    String? readFirstCheckoutUrl(Map<String, dynamic> source) {
      const keys = [
        'checkout_url',
        'checkoutUrl',
        'checkout_link',
        'checkoutLink',
        'payment_url',
        'paymentUrl',
        'url',
        'link',
      ];

      for (final key in keys) {
        final value = source[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      return null;
    }

    final directUrl = readFirstCheckoutUrl(json);
    final nestedData = json['data'];
    final nestedUrl = nestedData is Map<String, dynamic>
        ? readFirstCheckoutUrl(nestedData)
        : null;

    final message = json['message'];

    return PaymentResponseModel(
      raw: json,
      checkoutUrl: directUrl ?? nestedUrl,
      message: message is String ? message : null,
    );
  }
}

class PaymentStatusResult {
  final String bookingId;
  final String? status;

  const PaymentStatusResult({
    required this.bookingId,
    required this.status,
  });

  bool get isPaidOrActive {
    final normalized = status?.toLowerCase();
    return normalized == 'paid' ||
        normalized == 'assigned' ||
        normalized == 'ongoing' ||
        normalized == 'completed';
  }

  bool get needsRenewal {
    final normalized = status?.toLowerCase();
    return normalized == 'payment_failed' ||
        normalized == 'expired' ||
        normalized == 'booked' ||
        normalized == 'pending';
  }
}
