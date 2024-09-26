class Constant {
  static const baseUrl = "https://backend.hellohome.casa";
 // static const baseUrl = "https://frontend.hellohome.casa";
  // static const baseUrl = "https://hello.kitereative.com";
  // static const baseUrl = "https://hello-backend.kitereative.com";

  //AUTHTENTICATIONS
  static const login = "/api/auth/login";
  static const register = "/api/auth/register";
  static const otp = "/api/auth/otp";
  static const verify = "/api/auth/email/verify";
  static const resetPassword = "/api/auth/reset-password-with-email";

  //PRODUCT

  static const product = "/api/bestari/product";
  static const productSearch = "/api/bestari/product-search";

  //SUBSCRIPTION
  static const subscription = "/api/bestari/transaction";

  //PUSTAKA KATA
  static const notification = "/api/public/notifikasiapi";
  static const activity = "/api/auth/chat-activity/id_staff";
  // USER
  static const profile = "/api/bestari/user";


  //CARD
  static const purchase_card = "/api/bestari/purchase-card";
  static const activate_card = "/api/bestari/activate-card";
  static const check_card_code = "/api/auth/unique-cardcode-user";

  //UTILS
  static const publicAssets = "/storage/app/public/";
  //CHATS
  // static const serverUrl = "https://node-chat-hello.kitereative.com";
  // static const serverUrl = "https://node.chatnew.kitereative.com";
  static const serverUrl = "https://nodejs.hellohome.casa";
  // static const serverUrl = "https://socket-gilt.vercel.app";

  //MEMBER
  static const roleUserStaff = "/api/bestari/user/role-user-staff";
  static const addMemberByEmail = "/api/bestari/user-from-owner";
  static const staffOwner = "/api/bestari/staff-owner";
}
