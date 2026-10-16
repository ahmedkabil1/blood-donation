/// Mock data used by the frontend demo. Nothing here comes from a server.

class BloodRequest {
  const BloodRequest({
    required this.hospital,
    required this.region,
    required this.bloodGroup,
    required this.units,
    required this.daysLeft,
  });

  final String hospital;
  final String region;
  final String bloodGroup;
  final int units;
  final int daysLeft;
}

class DonationCenter {
  const DonationCenter({
    required this.name,
    required this.address,
    required this.region,
    required this.hours,
    required this.distanceKm,
    required this.phone,
    this.available = true,
  });

  final String name;
  final String address;
  final String region;
  final String hours;
  final double distanceKm;
  final String phone;
  final bool available;
}

class CompatRow {
  const CompatRow(this.group, this.gives, this.receives);

  final String group;
  final List<String> gives;
  final List<String> receives;
}

class MockData {
  MockData._();

  /// Demo OTP accepted by the simulated verification screen.
  static const otpCode = '123456';

  /// Order used by the blood-group grids ('+' first so that, in RTL, it sits
  /// on the right like in the Figma design).
  static const bloodGroups = <String>['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];

  static const urgencyLevels = <String>['عاجل جداً (خلال 24 ساعة)', 'عاجل (خلال 3 أيام)', 'عادي (خلال أسبوع)'];

  static const regions = <String>['القاهرة', 'الشرقية', 'المنيا'];

  static const timeSlots = <String>['9:00', '10:00', '11:00', '12:00'];

  static const requests = <BloodRequest>[
    BloodRequest(hospital: 'مستشفى العاصمه-منيا القمح', region: 'الشرقية', bloodGroup: 'O+', units: 3, daysLeft: 2),
    BloodRequest(hospital: 'مستشفى معهد ناصر-القاهره', region: 'القاهرة', bloodGroup: 'A-', units: 5, daysLeft: 1),
    BloodRequest(hospital: 'مستشفى طه يس-منيا القمح', region: 'الشرقية', bloodGroup: 'B+', units: 7, daysLeft: 3),
    BloodRequest(hospital: 'مستشفى المنيا الجامعي', region: 'المنيا', bloodGroup: 'O-', units: 2, daysLeft: 4),
    BloodRequest(hospital: 'مستشفى الزقازيق الجامعي', region: 'الشرقية', bloodGroup: 'AB+', units: 4, daysLeft: 5),
  ];

  static const centers = <DonationCenter>[
    DonationCenter(name: 'مركز القصر العيني', address: 'شارع القصر العيني ، السيده زينب القاهره', region: 'القاهرة', hours: '8:00 ص -10:00م', distanceKm: 1.2, phone: '0227654321'),
    DonationCenter(name: 'مركز العباسية للدم', address: 'شارع الخليفة المأمون ، العباسية القاهره', region: 'القاهرة', hours: '8:00 ص -10:00م', distanceKm: 3.4, phone: '0222345678'),
    DonationCenter(name: 'مركز مدينة نصر', address: 'شارع عباس العقاد ، مدينة نصر القاهره', region: 'القاهرة', hours: '9:00 ص -9:00م', distanceKm: 6.8, phone: '0224567890'),
    DonationCenter(name: 'مركز منيا القمح', address: 'شارع المستشفى ، منيا القمح الشرقية', region: 'الشرقية', hours: '8:00 ص -8:00م', distanceKm: 12.5, phone: '0552345678'),
    DonationCenter(name: 'مركز الزقازيق', address: 'شارع الجامعة ، الزقازيق الشرقية', region: 'الشرقية', hours: '8:00 ص -10:00م', distanceKm: 18.0, phone: '0553456789', available: false),
    DonationCenter(name: 'مركز المنيا الجامعي', address: 'كورنيش النيل ، المنيا', region: 'المنيا', hours: '8:00 ص -6:00م', distanceKm: 25.3, phone: '0862345678'),
  ];

  /// Branches offered in the appointment flow.
  static List<String> get branches => <String>['مستشفى العاصمه-منيا القمح', ...centers.map((c) => c.name)];

  /// Blood group compatibility (standard ABO/Rh rules).
  static const compatibility = <CompatRow>[
    CompatRow('O+', ['O+', 'A+', 'B+', 'AB+'], ['O-', 'O+']),
    CompatRow('O-', ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'], ['O-']),
    CompatRow('A+', ['A+', 'AB+'], ['O-', 'O+', 'A-', 'A+']),
    CompatRow('A-', ['A-', 'A+', 'AB-', 'AB+'], ['O-', 'A-']),
    CompatRow('B+', ['B+', 'AB+'], ['O-', 'O+', 'B-', 'B+']),
    CompatRow('B-', ['B-', 'B+', 'AB-', 'AB+'], ['O-', 'B-']),
    CompatRow('AB+', ['AB+'], ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+']),
    CompatRow('AB-', ['AB-', 'AB+'], ['O-', 'A-', 'B-', 'AB-']),
  ];
}
