///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  09 Jul 2019
///
///

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:stocks_mvc/src/view.dart';

import 'package:stocks_mvc/src/controller.dart' as con;

class StocksApp extends AppView {
  StocksApp()
      : super(
          con: con.AppStocks(),
          title: 'Stocks',
          theme: con.AppStocks.theme,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            con.AppStocks.localizationsDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale('en', 'US'),
            Locale('es', 'ES'),
          ],
        );

  onRoutes() => <String, WidgetBuilder>{
        '/': (BuildContext context) => StockHome(),
        '/settings': (BuildContext context) => StockSettings(),
      };

  onOnGenerateRoute() => (RouteSettings settings) {
        if (settings.name == '/stock') {
          final String symbol = settings.arguments;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) =>
                con.AppStocks.symbolPage(symbol: symbol),
          );
        }
        // The other paths we support are in the routes table.
        return null;
      };
}
