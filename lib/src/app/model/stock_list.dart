// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:stocks_mvc/src/app/model/stock_data.dart';
import 'package:stocks_mvc/src/app/model/stock_row.dart';

class StockList extends StatelessWidget {
  const StockList(
      {Key key, this.stocks, this.onOpen, this.onShow, this.onAction})
      : super(key: key);

  final List<Stock> stocks;
  final StockRowActionCallback onOpen;
  final StockRowActionCallback onShow;
  final StockRowActionCallback onAction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const ValueKey<String>('stock-list'),
      itemExtent: StockRow.kHeight,
      itemCount: stocks.length,
      itemBuilder: (BuildContext context, int index) {
        return StockRow(
          stock: stocks[index],
          onPressed: onOpen,
          onDoubleTap: onShow,
          onLongPressed: onAction,
        );
      },
    );
  }
}
