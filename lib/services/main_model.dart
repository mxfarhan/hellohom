import 'package:foodly/services/activity_service.dart';
import 'package:foodly/services/socket_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

import './purchase_card_service.dart';
import './user_services.dart';
import './product_services.dart';
import './subscription_service.dart';
import './chat_services.dart';
import './member_service.dart';
// import './aktivitas_service.dart';

class MainModel extends Model
    with
        UserService,
        ProductService,
        PurchaseCardService,
        ActivityService,
        SubscriptionService,
        ChatService,
        SocketService,
        MemberService {}
