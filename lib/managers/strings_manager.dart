class StringsManager {
  static const String appName = 'TopShop';
  static const String firstTimeLogin =
      'Account verification email is sent to you. Please verify your account to login.';
  static const String firstTimeLoginTitle = 'First Login to Proceed';
  static const String loginTxt = 'Login';
  static const String loginAccTxt = 'Login to your account';
  static const String emailTxt = 'Email Address';
  static const String passwordTxt = 'Password';
  static const String forgotPassTxt = 'Forgot Password?';
  static const String noAccTxt = 'Don\'t have an account? ';
  static const String alreadyHaveAccTxt = 'Already have an account? ';
  static const String welcomTxt = 'Welcome Back';
  static const String offlineTxt = "You're Offline.";
  static const String myProductsTxt = "My Products";
  static const String allProductsTxt = "All Products";
  static const String myCartTxt = "My Cart";
  static const String myOrdersTxt = "My Orders";
  static const String favouriteTxt = "Favourite Products";
  static const String ordersPlacedTxt = "Orders Log";
  static const String addressTxt = "Address";
  static const String addProdTxt = "Add Product";
  static const String editProdTxt = "Edit Product";
  static const String prodNameTxt = "Product Name";
  static const String prodImgTxt = "Product Image";
  static const String priceTxt = "Price";
  static const String stockQtyTxt = "Stock Quantity";

  static const String descriptionTxt = 'Description';
  static const String registerNowTxt = 'Create your account';
  static const String noProducttTxt = "No product found!";

  static const String offlineMsgTxt =
      "No Internet Connection. Make sure that Wifi or Mobile data is turned on, then try again.";
  static const String openWifiTxt = "Open Wifi Settings";
  static const String openDataTxt = "Open Data Settings";

  static const String registerTxt = 'Register';
  static const String nameTxt = 'Full Name';
  static const String phoneTxt = 'Phone number';
  static const String changePasswordTxt = 'Change password';
  static const String oldPasswordTxt = 'Old Password';
  static const String newPasswordTxt = 'New Password';
  static const String newRePasswordTxt = 'Re-Enter Pass';
  static const String privacyPolicyTxt = 'Privacy and policy';
  static const String updateProfileTxt = 'Update Profile';

  // Hint Text
  static const String emailHintTxt = 'abc@gmail.com';
  static const String phoneHintTxt = '0331XXXXXXX';
}

class ErrorManager {
  // form field error
  static const String kProductNameNullError = 'Please enter product name';
  static const String kaddressNullError = 'Please enter your address';
  static const String kUserNameNullError = 'Please enter your name';
  static const String kInvalidPriceError =
      'Please enter a price greater than 0.';
  static const String kInvalidStockError =
      'Please enter a stock greater than 0.';
  static const String kFieldEmptyError = 'Please Enter a value';
  static const String kPriceEmptyError = 'Please enter a valid price.';
  static const String kStockEmptyError = 'Please enter a valid price.';
  static const String kEmailNullError = 'Please Enter a valid email';
  static const String kPhoneNullError = 'Please Enter a phone number';
  static const String kDescriptionNullError = 'Please enter description';

  static const String kPasswordNullError = 'Please enter a password';
  static const String kPasswordNotMatchingError = 'Passwords do not Match';
  static const String kPasswordShortError =
      'Please Enter a Password of at least 8 digit';
  static const String kPasswordNotSameError =
      'Confirm Password should be same as New Password';

  static const String kGenderNullError = 'Please Select a Gender';
}
