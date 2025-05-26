class CustomerInfo {
  final String name;
  final String licensePlate;
  final String taxId; // ΑΦΜ
  final String contractStartDate;
  final String contractEndDate;
  final String phone;
  final String email;
  final String homeAddress;
  final String currentAddress;

  CustomerInfo({
    required this.name,
    required this.licensePlate,
    required this.taxId,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.phone,
    required this.email,
    required this.homeAddress,
    required this.currentAddress,
  });
}
