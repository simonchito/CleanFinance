class IconOption {
  const IconOption({
    required this.key,
    required this.labelKey,
  });

  final String key;
  final String labelKey;
}

abstract final class IconOptions {
  static const String defaultKey = 'category';

  static const List<IconOption> all = [
    IconOption(key: 'category', labelKey: 'iconOptionCategory'),
    IconOption(key: 'home', labelKey: 'iconOptionHome'),
    IconOption(key: 'bolt', labelKey: 'iconOptionBolt'),
    IconOption(key: 'restaurant', labelKey: 'iconOptionRestaurant'),
    IconOption(key: 'car', labelKey: 'iconOptionCar'),
    IconOption(key: 'health', labelKey: 'iconOptionHealth'),
    IconOption(key: 'education', labelKey: 'iconOptionEducation'),
    IconOption(key: 'shopping', labelKey: 'iconOptionShopping'),
    IconOption(key: 'entertainment', labelKey: 'iconOptionEntertainment'),
    IconOption(key: 'finance', labelKey: 'iconOptionFinance'),
    IconOption(key: 'family', labelKey: 'iconOptionFamily'),
    IconOption(key: 'work', labelKey: 'iconOptionWork'),
    IconOption(key: 'payments', labelKey: 'iconOptionPayments'),
    IconOption(key: 'storefront', labelKey: 'iconOptionStorefront'),
    IconOption(key: 'savings', labelKey: 'iconOptionSavings'),
    IconOption(key: 'shield', labelKey: 'iconOptionShield'),
    IconOption(key: 'flight', labelKey: 'iconOptionFlight'),
    IconOption(key: 'palette', labelKey: 'iconOptionPalette'),
    IconOption(key: 'kitchen', labelKey: 'iconOptionKitchen'),
    IconOption(key: 'receipt', labelKey: 'iconOptionReceipt'),
    IconOption(
        key: 'cleaning_services', labelKey: 'iconOptionCleaningServices'),
    IconOption(key: 'build', labelKey: 'iconOptionBuild'),
    IconOption(key: 'chair', labelKey: 'iconOptionChair'),
    IconOption(key: 'handyman', labelKey: 'iconOptionHandyman'),
    IconOption(key: 'water_drop', labelKey: 'iconOptionWaterDrop'),
    IconOption(key: 'tv', labelKey: 'iconOptionTv'),
    IconOption(
        key: 'local_fire_department',
        labelKey: 'iconOptionLocalFireDepartment'),
    IconOption(key: 'wifi', labelKey: 'iconOptionWifi'),
    IconOption(key: 'electric_bolt', labelKey: 'iconOptionElectricBolt'),
    IconOption(key: 'cloud', labelKey: 'iconOptionCloud'),
    IconOption(key: 'play_circle', labelKey: 'iconOptionPlayCircle'),
    IconOption(key: 'phone', labelKey: 'iconOptionPhone'),
    IconOption(key: 'coffee', labelKey: 'iconOptionCoffee'),
    IconOption(key: 'set_meal', labelKey: 'iconOptionSetMeal'),
    IconOption(key: 'delivery_dining', labelKey: 'iconOptionDeliveryDining'),
    IconOption(key: 'bakery_dining', labelKey: 'iconOptionBakeryDining'),
    IconOption(key: 'restaurant_menu', labelKey: 'iconOptionRestaurantMenu'),
    IconOption(key: 'shopping_cart', labelKey: 'iconOptionShoppingCart'),
    IconOption(key: 'eco', labelKey: 'iconOptionEco'),
    IconOption(key: 'local_gas_station', labelKey: 'iconOptionLocalGasStation'),
    IconOption(key: 'local_parking', labelKey: 'iconOptionLocalParking'),
    IconOption(key: 'toll', labelKey: 'iconOptionToll'),
    IconOption(key: 'security', labelKey: 'iconOptionSecurity'),
    IconOption(key: 'local_taxi', labelKey: 'iconOptionLocalTaxi'),
    IconOption(key: 'directions_bus', labelKey: 'iconOptionDirectionsBus'),
    IconOption(
        key: 'emoji_transportation', labelKey: 'iconOptionEmojiTransportation'),
    IconOption(key: 'medical_services', labelKey: 'iconOptionMedicalServices'),
    IconOption(key: 'science', labelKey: 'iconOptionScience'),
    IconOption(key: 'medication', labelKey: 'iconOptionMedication'),
    IconOption(key: 'health_and_safety', labelKey: 'iconOptionHealthAndSafety'),
    IconOption(key: 'mood', labelKey: 'iconOptionMood'),
    IconOption(key: 'visibility', labelKey: 'iconOptionVisibility'),
    IconOption(key: 'menu_book', labelKey: 'iconOptionMenuBook'),
    IconOption(key: 'book', labelKey: 'iconOptionBook'),
    IconOption(key: 'edit', labelKey: 'iconOptionEdit'),
    IconOption(key: 'school', labelKey: 'iconOptionSchool'),
    IconOption(key: 'hiking', labelKey: 'iconOptionHiking'),
    IconOption(key: 'language', labelKey: 'iconOptionLanguage'),
    IconOption(key: 'card_giftcard', labelKey: 'iconOptionCardGiftcard'),
    IconOption(key: 'checkroom', labelKey: 'iconOptionCheckroom'),
    IconOption(key: 'devices', labelKey: 'iconOptionDevices'),
    IconOption(key: 'movie', labelKey: 'iconOptionMovie'),
    IconOption(key: 'event', labelKey: 'iconOptionEvent'),
    IconOption(key: 'sports_esports', labelKey: 'iconOptionSportsEsports'),
    IconOption(key: 'nightlife', labelKey: 'iconOptionNightlife'),
    IconOption(
        key: 'account_balance_wallet',
        labelKey: 'iconOptionAccountBalanceWallet'),
    IconOption(key: 'receipt_long', labelKey: 'iconOptionReceiptLong'),
    IconOption(key: 'percent', labelKey: 'iconOptionPercent'),
    IconOption(key: 'business', labelKey: 'iconOptionBusiness'),
    IconOption(key: 'credit_card', labelKey: 'iconOptionCreditCard'),
    IconOption(key: 'self_improvement', labelKey: 'iconOptionSelfImprovement'),
    IconOption(key: 'child_care', labelKey: 'iconOptionChildCare'),
    IconOption(key: 'child_friendly', labelKey: 'iconOptionChildFriendly'),
    IconOption(key: 'pets', labelKey: 'iconOptionPets'),
    IconOption(key: 'lunch_dining', labelKey: 'iconOptionLunchDining'),
    IconOption(key: 'commute', labelKey: 'iconOptionCommute'),
    IconOption(
        key: 'volunteer_activism', labelKey: 'iconOptionVolunteerActivism'),
    IconOption(key: 'warning', labelKey: 'iconOptionWarning'),
    IconOption(key: 'more_horiz', labelKey: 'iconOptionMoreHoriz'),
  ];

  static final Map<String, String> _labelKeysByKey = {
    for (final option in all) option.key: option.labelKey,
  };

  static bool isSupported(String? key) {
    if (key == null) {
      return false;
    }
    return _labelKeysByKey.containsKey(key);
  }

  static String normalize(String? key) {
    if (isSupported(key)) {
      return key!;
    }
    return defaultKey;
  }

  static String labelKeyFor(String? key) {
    return _labelKeysByKey[normalize(key)] ?? _labelKeysByKey[defaultKey]!;
  }
}
