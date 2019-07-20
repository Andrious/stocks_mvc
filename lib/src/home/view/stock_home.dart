// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart' show DragStartBehavior;

import 'package:stocks_mvc/src/view.dart';

import 'package:stocks_mvc/src/controller.dart' as cont;

typedef ModeUpdater = void Function(StockMode mode);

enum StockHomeTab { market, portfolio }

class StockHome extends StatefulWidget {
  @override
  StockHomeState createState() => StockHomeState();
}

class StockHomeState extends StateMVC<StockHome> {
  StockHomeState() : super(cont.StockHome()) {
    con = this.controller;
  }
  cont.StockHome con;

  @override
  Widget build(BuildContext context) {
    return _degree01;
  }

  Widget get _degree01 => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawerDragStartBehavior: DragStartBehavior.down,
          key: con.scaffoldKey,
          appBar: con.widget.appBar,
          floatingActionButton: con.widget.floatingButton.createCompany,
          drawer: Drawer(
            child: ListView(
              dragStartBehavior: DragStartBehavior.down,
              children: <Widget>[
                const DrawerHeader(child: Center(child: Text('Stocks'))),
                ListTile(
                  leading: Icon(Icons.assessment),
                  title: con.title.stockList,
                  selected: true,
                ),
                ListTile(
                  leading: Icon(Icons.account_balance),
                  title: con.title.balance,
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.dvr),
                  title: con.title.dumpConsole,
                  onTap: con.onTap.dumpConsole,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.thumb_up),
                  title: con.title.optimistic,
                  trailing: Radio<StockMode>(
                    value: StockMode.optimistic,
                    groupValue: cont.AppStocks.stockMode,
                    onChanged: con.handleStockModeChange,
                  ),
                  onTap: con.onTap.optimistic,
                ),
                ListTile(
                  leading: const Icon(Icons.thumb_down),
                  title: con.title.pessimistic,
                  trailing: Radio<StockMode>(
                    value: StockMode.pessimistic,
                    groupValue: cont.AppStocks.stockMode,
                    onChanged: con.handleStockModeChange,
                  ),
                  onTap: con.onTap.pessimistic,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: con.title.settings,
                  onTap: () {
                    con.onTap.settings(con.context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: con.title.about,
                  onTap: () {
                    con.onTap.about(con.context);
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            children: <Widget>[
              con.widget.marketTab,
              con.widget.portfolioTab,
            ],
          ),
        ),
      );

  Widget get _degree02 => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawerDragStartBehavior: DragStartBehavior.down,
          key: con.scaffoldKey,
          appBar: con.widget.appBar,
          floatingActionButton: con.widget.floatingButton.createCompany,
          drawer: Drawer(
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
          ),
          body: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            children: <Widget>[
              con.widget.marketTab,
              con.widget.portfolioTab,
            ],
          ),
        ),
      );

  Widget get _degree03 => DefaultTabController(
    length: 2,
    child: Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      key: con.scaffoldKey,
      appBar: con.widget.appBar,
      floatingActionButton: con.widget.floatingButton.createCompany,
      drawer: con.widget.drawer,
      body: con.widget.body,
    ),
  );
}
