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
    return DefaultTabController(
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
  }
}
