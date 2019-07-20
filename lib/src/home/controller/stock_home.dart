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
///          Created  12 Jul 2019
///
///
///
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:stocks_mvc/src/model.dart';
import 'package:stocks_mvc/src/view.dart';
import 'package:stocks_mvc/src/controller.dart';

class StockHome extends ControllerMVC {
  factory StockHome() {
    _this ??= StockHome._();
    return _this;
  }
  StockHome._();
  static StockHome _this;

  @override
  void initState() {
    _widget = _Widgets(this);
    _title = _Titles(this);
    _onTaps = OnTaps(this);
  }

  @override
  void dispose() {
    _this = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _widget.didChangeDependencies();
  }

  List<String> portfolioSymbols = <String>[
    'AAPL',
    'FIZZ',
    'FIVE',
    'FLAT',
    'ZINC',
    'ZNGA'
  ];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _Titles get title => _title;
  _Titles _title;

  _Widgets get widget => _widget;
  _Widgets _widget;

  OnTaps get onTap => _onTaps;
  OnTaps _onTaps;

  BuildContext get context => this.stateMVC.context;

  Widget buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: _widget.appBarTitle,
      actions: <Widget>[
        _widget.search,
        _widget.popMenu,
      ],
      bottom: TabBar(
        tabs: <Widget>[
          _widget.market,
          _widget.portfolio,
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return AppBar(
      leading: BackButton(
        color: Theme.of(context).accentColor,
      ),
      title: TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search stocks',
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  Widget buildStockTab(
      BuildContext context, StockHomeTab tab, List<String> stockSymbols) {
    return AnimatedBuilder(
      key: ValueKey<StockHomeTab>(tab),
      animation: Listenable.merge(<Listenable>[_searchQuery, AppStocks.stocks]),
      builder: (BuildContext context, Widget child) {
        return _buildStockList(
            context,
            _filterBySearchQuery(_getStockList(AppStocks.stocks, stockSymbols))
                .toList(),
            tab);
      },
    );
  }

  Widget _buildStockList(
      BuildContext context, Iterable<Stock> stocks, StockHomeTab tab) {
    return StockList(
      stocks: stocks.toList(),
      onAction: _buyStock,
      onOpen: (Stock stock) {
        Navigator.pushNamed(context, '/stock', arguments: stock.symbol);
      },
      onShow: (Stock stock) {
        this.scaffoldKey.currentState.showBottomSheet<void>(
            (BuildContext context) => StockSymbolBottomSheet(stock: stock));
      },
    );
  }

  void _handleStockMenu(BuildContext context, _StockMenuItem value) {
    switch (value) {
      case _StockMenuItem.autorefresh:
        setState(() {
          _autorefresh = !_autorefresh;
        });
        break;
      case _StockMenuItem.refresh:
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => _NotImplementedDialog(),
        );
        break;
      case _StockMenuItem.speedUp:
        timeDilation /= 5.0;
        break;
      case _StockMenuItem.speedDown:
        timeDilation *= 5.0;
        break;
    }
  }

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _isSearching = false;
          _searchQuery.clear();
        });
      },
    ));
    setState(() {
      _isSearching = true;
    });
  }

  void _buyStock(Stock stock) {
    setState(() {
      stock.percentChange = 100.0 * (1.0 / stock.lastSale);
      stock.lastSale += 1.0;
    });
    this.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Purchased ${stock.symbol} for ${stock.lastSale}'),
          action: SnackBarAction(
            label: 'BUY MORE',
            onPressed: () {
              _buyStock(stock);
            },
          ),
        ));
  }

  Iterable<Stock> _getStockList(StockData stocks, Iterable<String> symbols) {
    return symbols
        .map<Stock>((String symbol) => stocks[symbol])
        .where((Stock stock) => stock != null);
  }

  Iterable<Stock> _filterBySearchQuery(Iterable<Stock> stocks) {
    if (_searchQuery.text.isEmpty) return stocks;
    final RegExp regexp = RegExp(_searchQuery.text, caseSensitive: false);
    return stocks.where((Stock stock) => stock.symbol.contains(regexp));
  }

  void handleStockModeChange(StockMode value) {
    AppStocks.stockMode = value;
  }
}

class _Titles {
  _Titles(this.con);
  StockHome con;

  Widget stockList = const Text('Stock List');

  Widget balance = const Text('Account Balance');

  Widget dumpConsole = const Text('Dump App to Console');

  Widget optimistic = const Text('Optimistic');

  Widget pessimistic = const Text('Pessimistic');

  Widget settings = const Text('Settings');

  Widget about = const Text('About');
}

class _Widgets {
  _Widgets(this.con) {
    listTiles = _ListTiles(con);
    _appBar = _AppBar(con);
    _drawer = _Drawer(con);
    _body = _Body(con);
  }
  StockHome con;
  _ListTiles listTiles;
  _AppBar _appBar;
  _Drawer _drawer;
  _Body _body;
  _FloatingActionButton _floatingButton;

  Widget get drawer => _drawer.drawer;

  Widget get body => _body.body;

  Widget get appBar => _isSearching ? con.buildSearchBar() : con.buildAppBar();

  Widget get stockList => listTiles.stockList;

  Widget get accountBalance => listTiles.accountBalance;

  Widget get dumpConsole => listTiles.dumpConsole;

  Widget get optimistic => listTiles.optimistic;

  Widget get pessimistic => listTiles.pessimistic;

  Widget get settings => listTiles.settings;

  Widget get about => listTiles.about;

  Widget get appBarTitle => _appBar.appBarTitle;

  Widget get search => _appBar.search;

  Widget get popMenu => _appBar.popMenu;

  Widget get market => _appBar.market;

  Widget get portfolio => _appBar.portfolio;

  void didChangeDependencies() {
    _floatingButton = _FloatingActionButton(con);
    _appBar.stockStrings();
  }

  Widget get marketTab => con.buildStockTab(
      con.context, StockHomeTab.market, AppStocks.stocks.allSymbols);

  Widget get portfolioTab => con.buildStockTab(
      con.context, StockHomeTab.portfolio, con.portfolioSymbols);

  _FloatingActionButton get floatingButton => _floatingButton;
}

class _AppBar {
  _AppBar(this.con) {
    popMenu = PopupMenuButton(
      onSelected: (_StockMenuItem value) {
        con._handleStockMenu(con.context, value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<_StockMenuItem>>[
        autoRefresh,
        refresh,
        increase,
        decrease,
      ],
    );

    search = IconButton(
      icon: const Icon(Icons.search),
      onPressed: con._handleSearchBegin,
      tooltip: 'Search',
    );
  }
  StockHome con;
  PopupMenuButton<_StockMenuItem> popMenu;
  IconButton search;
  Tab market;
  Tab portfolio;
  Text appBarTitle;

  void stockStrings() {
    market = Tab(text: StockStrings.of(con.context).market());

    portfolio = Tab(text: StockStrings.of(con.context).portfolio());

    appBarTitle = Text(StockStrings.of(con.context).title());
  }

  CheckedPopupMenuItem<_StockMenuItem> autoRefresh = CheckedPopupMenuItem(
    value: _StockMenuItem.autorefresh,
    checked: _autorefresh,
    child: const Text('Autorefresh'),
  );

  PopupMenuItem<_StockMenuItem> refresh = const PopupMenuItem(
    value: _StockMenuItem.refresh,
    child: Text('Refresh'),
  );

  PopupMenuItem<_StockMenuItem> increase = const PopupMenuItem(
    value: _StockMenuItem.speedUp,
    child: Text('Increase animation speed'),
  );

  PopupMenuItem<_StockMenuItem> decrease = const PopupMenuItem(
    value: _StockMenuItem.speedDown,
    child: Text('Decrease animation speed'),
  );
}

class _FloatingActionButton {
  _FloatingActionButton(StockHome con) {
    _createCompany = FloatingActionButton(
      tooltip: 'Create company',
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(con.context).accentColor,
      onPressed: () {
        showModalBottomSheet<void>(
          context: con.context,
          builder: (BuildContext context) => _CreateCompanySheet(),
        );
      },
    );
  }
  FloatingActionButton get createCompany => _createCompany;
  FloatingActionButton _createCompany;
}

class _CreateCompanySheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Company Name',
          ),
        ),
        Text('(This demo is not yet complete.)'),
        // For example, we could add a button that actually updates the list
        // and then contacts the server, etc.
      ],
    );
  }
}

class _ListTiles {
  _ListTiles(this.con);
  StockHome con;

  ListTile stockList = const ListTile(
    leading: Icon(Icons.assessment),
    title: Text('Stock List'),
    selected: true,
  );

  ListTile accountBalance = const ListTile(
    leading: Icon(Icons.account_balance),
    title: Text('Account Balance'),
    enabled: false,
  );

  ListTile dumpConsole = ListTile(
    leading: const Icon(Icons.dvr),
    title: const Text('Dump App to Console'),
    onTap: () {
      try {
        debugDumpApp();
        debugDumpRenderTree();
        debugDumpLayerTree();
        debugDumpSemanticsTree(DebugSemanticsDumpOrder.traversalOrder);
      } catch (e, stack) {
        debugPrint('Exception while dumping app:\n$e\n$stack');
      }
    },
  );

  ListTile get optimistic => ListTile(
        leading: const Icon(Icons.thumb_up),
        title: const Text('Optimistic'),
        trailing: Radio<StockMode>(
          value: StockMode.optimistic,
          groupValue: AppStocks.stockMode,
          onChanged: con.handleStockModeChange,
        ),
        onTap: () {
          con.handleStockModeChange(StockMode.optimistic);
          con.stateMVC.refresh();
        },
      );

  ListTile get pessimistic => ListTile(
        leading: const Icon(Icons.thumb_down),
        title: const Text('Pessimistic'),
        trailing: Radio<StockMode>(
          value: StockMode.pessimistic,
          groupValue: AppStocks.stockMode,
          onChanged: con.handleStockModeChange,
        ),
        onTap: () {
          con.handleStockModeChange(StockMode.pessimistic);
          con.stateMVC.refresh();
        },
      );

  ListTile get settings => ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () => con.onTap.settings(con.context),
      );

  ListTile get about => ListTile(
        leading: const Icon(Icons.help),
        title: const Text('About'),
        onTap: () => con.onTap.about(con.context),
      );
}

class OnTaps {
  OnTaps(this.con);
  StockHome con;

  GestureTapCallback get dumpConsole => () {
        try {
          debugDumpApp();
          debugDumpRenderTree();
          debugDumpLayerTree();
          debugDumpSemanticsTree(DebugSemanticsDumpOrder.traversalOrder);
        } catch (e, stack) {
          debugPrint('Exception while dumping app:\n$e\n$stack');
        }
      };

  GestureTapCallback get optimistic => () {
        con.handleStockModeChange(StockMode.optimistic);
        con.stateMVC.refresh();
      };

  GestureTapCallback get pessimistic => () {
        con.handleStockModeChange(StockMode.pessimistic);
        con.stateMVC.refresh();
      };

  settings(BuildContext context) {
    Navigator.popAndPushNamed(context, '/settings');
  }

  about(BuildContext context) {
    showAboutDialog(context: context);
  }
}

class _Drawer {
  _Drawer(this.con);
  StockHome con;

  Widget get drawer => Drawer(
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          children: <Widget>[
            const DrawerHeader(child: Center(child: Text('Stocks'))),
            con.widget.stockList,
            con.widget.accountBalance,
            con.widget.dumpConsole,
            const Divider(),
            con.widget.optimistic,
            con.widget.pessimistic,
            const Divider(),
            con.widget.settings,
            con.widget.about,
          ],
        ),
      );
}

class _Body{
  _Body(this.con);
  StockHome con;

  Widget get body => TabBarView(
    dragStartBehavior: DragStartBehavior.down,
    children: <Widget>[
      con.widget.marketTab,
      con.widget.portfolioTab,
    ],
  );
}

class _NotImplementedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Not Implemented'),
      content: const Text('This feature has not yet been implemented.'),
      actions: <Widget>[
        FlatButton(
          onPressed: debugDumpApp,
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.dvr,
                size: 18.0,
              ),
              Container(
                width: 8.0,
              ),
              const Text('DUMP APP TO CONSOLE'),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('OH WELL'),
        ),
      ],
    );
  }
}

final TextEditingController _searchQuery = TextEditingController();
bool _isSearching = false;
bool _autorefresh = false;

enum _StockMenuItem { autorefresh, refresh, speedUp, speedDown }
