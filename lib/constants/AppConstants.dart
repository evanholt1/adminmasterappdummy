class AppConstants {
  static var apiHeaders = {
    'Content-Type': 'application/json',
    "Accept": "application/json",
  };

  // static setApiToken(String token) {
  //   return apiHeaders.putIfAbsent("Authorization", () => "Bearer $token");
  // }
  //
  // static clearApiToken() => apiHeaders.remove("Authorization");
  //
  // static setVendorBranchId(int branchId) => apiHeaders.putIfAbsent("branchId", () => branchId.toString());
  //
  // static clearVendorBranchId() => apiHeaders.remove("branchId");
  //
  // static setDriverId(int driverId) => apiHeaders.putIfAbsent("driverId", () => driverId.toString());
  //
  // static clearDriverId() => apiHeaders.remove("driverId");
}
