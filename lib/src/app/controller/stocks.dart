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

import 'package:stocks_mvc/src/model.dart';
import 'package:stocks_mvc/src/view.dart';
import 'package:stocks_mvc/src/controller.dart';

class AppStocks extends AppController {
  factory AppStocks([StateMVC state]) {
    _this ??= AppStocks._(state);
    return _this;
  }
  static AppStocks _this;

  AppStocks._([StateMVC state]) : super(state);

  @override
  void initState() {
    _state = stateMVC;
    _stocks = StockData();
  }

  static AppView _state;
  static StockData _stocks;

  static bool get debugShowGrid => _state?.debugShowMaterialGrid;
  static set debugShowGrid(bool v) {
    _state?.debugShowMaterialGrid = v;
    _state?.refresh();
  }

  static bool get debugShowSizes => _state?.debugPaintSizeEnabled;
  static set debugShowSizes(bool v) {
    _state?.debugPaintSizeEnabled = v;
    _state?.refresh();
  }

  static bool get debugShowBaselines => _state?.debugPaintBaselinesEnabled;
  static set debugShowBaselines(bool v) {
    _state?.debugPaintBaselinesEnabled = v;
    _state?.refresh();
  }

  static bool get debugShowLayers => _state?.debugPaintLayerBordersEnabled;
  static set debugShowLayers(bool v) {
    _state?.debugPaintLayerBordersEnabled = v;
    _state?.refresh();
  }

  static bool get debugShowPointers => _state?.debugPaintPointersEnabled;
  static set debugShowPointers(bool v) {
    _state?.debugPaintPointersEnabled = v;
    _state?.refresh();
  }

  static bool get debugShowRainbow => _state?.debugRepaintRainbowEnabled;
  static set debugShowRainbow(bool v) {
    _state?.debugRepaintRainbowEnabled = v;
    _state?.refresh();
  }

  static bool get showPerformanceOverlay => _state?.showPerformanceOverlay;
  static set showPerformanceOverlay(bool v) {
    _state?.showPerformanceOverlay = v;
    _state?.refresh();
  }

  static bool get showSemanticsDebugger => _state?.showSemanticsDebugger;
  static set showSemanticsDebugger(bool v) {
    _state?.showSemanticsDebugger = v;
    _state?.refresh();
  }

  static ThemeData get theme {
    switch (stockMode) {
      case StockMode.optimistic:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
        );
      case StockMode.pessimistic:
        return ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.redAccent,
        );
    }
    return null;
  }
  static set theme(ThemeData v) {
    _state?.theme = v;
    _state?.refresh();
  }

  static StockMode get stockMode => _stockMode;
  static set stockMode(StockMode v) {
    _stockMode = v;
    _state?.theme = theme;
    _state?.refresh();
  }
  static StockMode _stockMode = StockMode.optimistic;

  static BackupMode get backupMode => _backupMode;
  static set backupMode(BackupMode v) {
    _backupMode = v;
    _state?.refresh();
  }
  static BackupMode _backupMode = BackupMode.enabled;

  
  static StockData get stocks => _stocks;

  static final _StocksLocalizationsDelegate localizationsDelegate =
      _StocksLocalizationsDelegate();

  static StockSymbolPage symbolPage({String symbol}) =>
      StockSymbolPage(symbol: symbol, stocks: AppStocks.stocks);
}

class _StocksLocalizationsDelegate extends LocalizationsDelegate<StockStrings> {
  @override
  Future<StockStrings> load(Locale locale) => StockStrings.load(locale);

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'es' || locale.languageCode == 'en';

  @override
  bool shouldReload(_StocksLocalizationsDelegate old) => false;
}
