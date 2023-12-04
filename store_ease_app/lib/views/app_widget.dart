import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../constants.dart';
import '../controllers/account/account_bloc.dart';
import '../controllers/auth_flow/auth/auth_bloc.dart';
import '../controllers/auth_flow/verify/verify_bloc.dart';
import '../controllers/bottom_tabs/bottom_tabs_bloc.dart';
import '../controllers/category/category_bloc.dart';
import '../controllers/menu/menu_bloc.dart';
import '../controllers/notification/notification_bloc.dart';
import '../controllers/order_ticket/order_ticket_bloc.dart';
import '../controllers/seat/seat_bloc.dart';
import '../controllers/store/store_bloc.dart';
import '../controllers/store_menu/store_menu_bloc.dart';
import '../controllers/theme/theme_bloc.dart';
import '../controllers/user_watcher/user_watcher_bloc.dart';
import '../models/enums/load_status_enum.dart';
import '../routes/app_router.dart';
import '../services/api_category.dart';
import '../services/api_fcm.dart';
import '../services/api_firebase.dart';
import '../services/api_menu.dart';
import '../services/api_order_ticket.dart';
import '../services/api_otp.dart';
import '../services/api_seat.dart';
import '../services/api_store.dart';
import '../services/api_store_menu.dart';
import '../services/api_user.dart';
import 'splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // 為了顯示訂單的ScaffoldMessenger需要一個GlobalKey
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => UserApi(),
        ),
        RepositoryProvider(
          create: (_) => OTPApi(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseApi(),
        ),
        RepositoryProvider(
          create: (_) => StoreApi(),
        ),
        RepositoryProvider(
          create: (_) => MenuApi(),
        ),
        RepositoryProvider(
          create: (_) => CategoryApi(),
        ),
        RepositoryProvider(
          create: (_) => StoreMenuApi(),
        ),
        RepositoryProvider(
          create: (_) => SeatApi(),
        ),
        RepositoryProvider(
          create: (_) => OrderTicketApi(),
        ),
        RepositoryProvider(
          create: (_) => FCMApi(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<UserApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => VerifyBloc(
              context.read<OTPApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => UserWatcherBloc(
              context.read<FirebaseApi>(),
              context.read<UserApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(
              context.read<UserApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => BottomTabsBloc(),
          ),
          BlocProvider(
            create: (context) => AccountBloc(
              context.read<UserApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => StoreBloc(
              context.read<StoreApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => MenuBloc(
              context.read<MenuApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              context.read<CategoryApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => StoreMenuBloc(
              context.read<StoreMenuApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => SeatBloc(
              context.read<SeatApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => OrderTicketBloc(
              context.read<OrderTicketApi>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              context.read<FCMApi>(),
            ),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<NotificationBloc, NotificationState>(
              listenWhen: (p, c) =>
                  p.isReceivingRemoteMessage != c.isReceivingRemoteMessage &&
                  c.isReceivingRemoteMessage == true,
              listener: (context, state) {
                final ThemeState themeState = context.read<ThemeBloc>().state;
                scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text(
                      themeState.languageCode == 'en'
                          ? 'Received a new order ticket'
                          : '收到新訂單',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                BlocProvider.of<NotificationBloc>(context).add(
                  const IsReceivingRemoteMessageEvent(false),
                );
              },
            ),
            BlocListener<NotificationBloc, NotificationState>(
              listenWhen: (p, c) => p.receiveStatus != c.receiveStatus,
              listener: (context, state) {
                if (state.receiveStatus == LoadStatus.succeed) {
                  BlocProvider.of<OrderTicketBloc>(context).add(
                    GetAllOrderTicketEvent(
                      state.getOrderStoreId,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                scaffoldMessengerKey: scaffoldMessengerKey,
                title: 'Store Ease',
                theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                  ),
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.orangeAccent,
                  ),
                  useMaterial3: true,
                ),
                locale: Locale(state.languageCode),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: localeMapList.map(
                  (item) => item['locale'],
                ),
                routes: routes,
                home: const SplashPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
