import 'package:intl/intl.dart';

const appDataBox = "app_data_box";
const userDataBox = "user_data_box";

const firstTimeKey = "first_time_key";
const userTokenKey = "user_token_key";
const userIDKey = "user_id_key";
const pushNotificationKey = "user_push_notification_key";

const appUrl = "https://pallytopit.com.ng";
const chatBaseUrl = "https://pallytopit.com.ng/inbox/api/";
const appBaseUrl = "https://pallytopit.com.ng/api/";
const attachementBaseUrl = "https://hustlebucket.s3.amazonaws.com/attachments/";
const audioBaseUrl = "https://dttc4kal57acd.cloudfront.net/";
const defaultProfilePicture = "https://pallytopit.com.ng/img/default/default-placeholder.jpg";

NumberFormat moneyFormatter = NumberFormat.currency(
  locale: 'en_US', // Change the locale based on your requirement
  symbol: 'N', // You can change the currency symbol as needed
);