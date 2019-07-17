// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'stock_types.dart';

import 'package:stocks_mvc/src/controller.dart';

class StockSettings extends StatefulWidget {
  @override
  StockSettingsState createState() => StockSettingsState();
}

class StockSettingsState extends State<StockSettings> {
  void _handleOptimismChanged(bool value) {
    value ??= false;
    AppStocks.stockMode = value ? StockMode.optimistic : StockMode.pessimistic;
  }

  void _handleBackupChanged(bool value) {
    value ??= true;
    AppStocks.backupMode = value ? BackupMode.enabled : BackupMode.disabled;
  }

  void _handleShowGridChanged(bool value) {
    AppStocks.debugShowGrid = value;
  }

  void _handleShowSizesChanged(bool value) {
    AppStocks.debugShowSizes = value;
}

  void _handleShowBaselinesChanged(bool value) {
    AppStocks.debugShowBaselines = value;
  }

  void _handleShowLayersChanged(bool value) {
    AppStocks.debugShowLayers = value;
  }

  void _handleShowPointersChanged(bool value) {
    AppStocks.debugShowPointers = value;
  }

  void _handleShowRainbowChanged(bool value) {
    AppStocks.debugShowRainbow = value;
  }

  void _handleShowPerformanceOverlayChanged(bool value) {
    AppStocks.showPerformanceOverlay = value;
  }

  void _handleShowSemanticsDebuggerChanged(bool value) {
    AppStocks.showSemanticsDebugger = value;
  }

//  void sendUpdates(StockConfiguration value) {
//    AppStocks.updater(value);
//  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
    );
  }

  Widget buildSettingsPane(BuildContext context) {
    final List<Widget> rows = <Widget>[
      ListTile(
        leading: const Icon(Icons.thumb_up),
        title: const Text('Everything is awesome'),
        onTap: _confirmOptimismChange,
        trailing: Checkbox(
          value: AppStocks.stockMode == StockMode.optimistic,
          onChanged: (bool value) => _confirmOptimismChange(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.backup),
        title: const Text('Back up stock list to the cloud'),
        onTap: () {
          _handleBackupChanged(
              !(AppStocks.backupMode == BackupMode.enabled));
        },
        trailing: Switch(
          value: AppStocks.backupMode == BackupMode.enabled,
          onChanged: _handleBackupChanged,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.picture_in_picture),
        title: const Text('Show rendering performance overlay'),
        onTap: () {
          _handleShowPerformanceOverlayChanged(
              !AppStocks.showPerformanceOverlay);
        },
        trailing: Switch(
          value: AppStocks.showPerformanceOverlay,
          onChanged: _handleShowPerformanceOverlayChanged,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.accessibility),
        title: const Text('Show semantics overlay'),
        onTap: () {
          _handleShowSemanticsDebuggerChanged(
              !AppStocks.showSemanticsDebugger);
        },
        trailing: Switch(
          value: AppStocks.showSemanticsDebugger,
          onChanged: _handleShowSemanticsDebuggerChanged,
        ),
      ),
    ];
    assert(() {
      // material grid and size construction lines are only available in checked mode
      rows.addAll(<Widget>[
        ListTile(
          leading: const Icon(Icons.border_clear),
          title: const Text('Show material grid (for debugging)'),
          onTap: () {
            _handleShowGridChanged(!AppStocks.debugShowGrid);
          },
          trailing: Switch(
            value: AppStocks.debugShowGrid,
            onChanged: _handleShowGridChanged,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.border_all),
          title: const Text('Show construction lines (for debugging)'),
          onTap: () {
            _handleShowSizesChanged(!AppStocks.debugShowSizes);
          },
          trailing: Switch(
            value: AppStocks.debugShowSizes,
            onChanged: _handleShowSizesChanged,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.format_color_text),
          title: const Text('Show baselines (for debugging)'),
          onTap: () {
            _handleShowBaselinesChanged(
                !AppStocks.debugShowBaselines);
          },
          trailing: Switch(
            value: AppStocks.debugShowBaselines,
            onChanged: _handleShowBaselinesChanged,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.filter_none),
          title: const Text('Show layer boundaries (for debugging)'),
          onTap: () {
            _handleShowLayersChanged(!AppStocks.debugShowLayers);
          },
          trailing: Switch(
            value: AppStocks.debugShowLayers,
            onChanged: _handleShowLayersChanged,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mouse),
          title: const Text('Show pointer hit-testing (for debugging)'),
          onTap: () {
            _handleShowPointersChanged(
                !AppStocks.debugShowPointers);
          },
          trailing: Switch(
            value: AppStocks.debugShowPointers,
            onChanged: _handleShowPointersChanged,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gradient),
          title: const Text('Show repaint rainbow (for debugging)'),
          onTap: () {
            _handleShowRainbowChanged(
                !AppStocks.debugShowRainbow);
          },
          trailing: Switch(
            value: AppStocks.debugShowRainbow,
            onChanged: _handleShowRainbowChanged,
          ),
        ),
      ]);
      return true;
    }());
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      children: rows,
    );
  }


  void _confirmOptimismChange() {
    switch (AppStocks.stockMode) {
      case StockMode.optimistic:
        _handleOptimismChanged(false);
        break;
      case StockMode.pessimistic:
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Change mode?'),
              content: const Text(
                  'Optimistic mode means everything is awesome. Are you sure you can handle that?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('NO THANKS'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: const Text('AGREE'),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        ).then<void>(_handleOptimismChanged);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildSettingsPane(context),
    );
  }
}
