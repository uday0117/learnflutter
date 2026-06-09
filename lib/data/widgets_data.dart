import 'package:flutter/material.dart';

import '../models/widget_category.dart';
import '../models/widget_model.dart';

class WidgetsData {
  static List<WidgetCategory> getCategories() {
    return [
      WidgetCategory(
        id: 'basic',
        name: 'Basic Widgets',
        description: '15 essential widgets',
        icon: Icons.text_fields,
        color: Colors.deepPurple,
        widgetCount: 15,
      ),
      WidgetCategory(
        id: 'layout',
        name: 'Layout Widgets',
        description: '18 layout widgets',
        icon: Icons.grid_view,
        color: Colors.blue,
        widgetCount: 18,
      ),
      WidgetCategory(
        id: 'input',
        name: 'Input Widgets',
        description: '10 input widgets',
        icon: Icons.input,
        color: Colors.green,
        widgetCount: 10,
      ),
      WidgetCategory(
        id: 'button',
        name: 'Button Widgets',
        description: '10 button widgets',
        icon: Icons.smart_button,
        color: Colors.orange,
        widgetCount: 10,
      ),
      WidgetCategory(
        id: 'list',
        name: 'List & Display',
        description: '12 list widgets',
        icon: Icons.list,
        color: Colors.pink,
        widgetCount: 12,
      ),
      WidgetCategory(
        id: 'navigation',
        name: 'Navigation',
        description: '10 navigation widgets',
        icon: Icons.navigation,
        color: Colors.purple,
        widgetCount: 10,
      ),
    ];
  }

  static List<WidgetModel> getAllWidgets() {
    return [
      // ============= BASIC WIDGETS (15) =============
      WidgetModel(
        id: 'text',
        name: 'Text',
        description: 'Display text with a single style',
        categoryId: 'basic',
        syntax: '''Text(
  'Hello World',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello Flutter!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}''',
        usage: 'Use Text widget to display strings in your Flutter app.',
        properties: [
          WidgetProperty(name: 'data', description: 'The text to display'),
          WidgetProperty(name: 'style', description: 'Text style to apply'),
          WidgetProperty(name: 'textAlign', description: 'Text alignment'),
        ],
      ),

      WidgetModel(
        id: 'icon',
        name: 'Icon',
        description: 'Display material design icons',
        categoryId: 'basic',
        syntax: '''Icon(
  Icons.favorite,
  size: 50,
  color: Colors.red,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class IconExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: 80,
      color: Colors.amber,
    );
  }
}''',
        usage: 'Display icons from Material Icons library.',
        properties: [
          WidgetProperty(name: 'icon', description: 'IconData to display'),
          WidgetProperty(name: 'size', description: 'Icon size'),
          WidgetProperty(name: 'color', description: 'Icon color'),
        ],
      ),

      WidgetModel(
        id: 'image',
        name: 'Image',
        description: 'Display images from various sources',
        categoryId: 'basic',
        syntax: '''Image.asset('assets/image.png')
Image.network('https://example.com/image.jpg')''',
        sourceCode: '''import 'package:flutter/material.dart';

class ImageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://flutter.dev/assets/flutter-lockup-c13da9c9303e26b8d5fc208d2a1fa20c1ef47eb021ecadf27046dea04c0cebf6.png',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}''',
        usage: 'Display images from assets, network, or memory.',
        properties: [
          WidgetProperty(name: 'image', description: 'Image source'),
          WidgetProperty(name: 'fit', description: 'How image should fit'),
          WidgetProperty(name: 'width/height', description: 'Image dimensions'),
        ],
      ),

      WidgetModel(
        id: 'container',
        name: 'Container',
        description: 'A box model widget with padding, margin, decoration',
        categoryId: 'basic',
        syntax: '''Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Hello'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ContainerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Center(child: Text('Container', style: TextStyle(color: Colors.white, fontSize: 20))),
    );
  }
}''',
        usage: 'Container is a versatile widget for styling and positioning.',
        properties: [
          WidgetProperty(name: 'padding', description: 'Inner spacing'),
          WidgetProperty(name: 'margin', description: 'Outer spacing'),
          WidgetProperty(name: 'decoration', description: 'Visual decoration'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'scaffold',
        name: 'Scaffold',
        description: 'Material Design visual layout structure',
        categoryId: 'basic',
        syntax: '''Scaffold(
  appBar: AppBar(title: Text('Title')),
  body: Center(child: Text('Content')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ScaffoldExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scaffold Example')),
      body: Center(child: Text('Main Content')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      drawer: Drawer(child: ListView(children: [DrawerHeader(child: Text('Menu')), ListTile(title: Text('Item 1'))])),
    );
  }
}''',
        usage: 'Scaffold provides basic material design layout structure.',
        properties: [
          WidgetProperty(name: 'appBar', description: 'Top app bar'),
          WidgetProperty(name: 'body', description: 'Main content'),
          WidgetProperty(name: 'floatingActionButton', description: 'FAB button'),
          WidgetProperty(name: 'drawer', description: 'Side drawer'),
        ],
      ),

      WidgetModel(
        id: 'appbar',
        name: 'AppBar',
        description: 'Material Design app bar',
        categoryId: 'basic',
        syntax: '''AppBar(
  title: Text('My App'),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('AppBar Example'),
      leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
      backgroundColor: Colors.deepPurple,
    );
  }
}''',
        usage: 'AppBar displays app title, actions, and navigation.',
        properties: [
          WidgetProperty(name: 'title', description: 'App bar title'),
          WidgetProperty(name: 'leading', description: 'Leading widget'),
          WidgetProperty(name: 'actions', description: 'Action widgets'),
        ],
      ),

      WidgetModel(
        id: 'divider',
        name: 'Divider',
        description: 'A thin horizontal line for separating content',
        categoryId: 'basic',
        syntax: '''Divider(
  color: Colors.grey,
  thickness: 2,
  indent: 16,
  endIndent: 16,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DividerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(title: Text('Item 1')),
        Divider(thickness: 2),
        ListTile(title: Text('Item 2')),
        Divider(color: Colors.blue, indent: 20, endIndent: 20),
        ListTile(title: Text('Item 3')),
      ],
    );
  }
}''',
        usage: 'Use Divider to separate content sections.',
        properties: [
          WidgetProperty(name: 'color', description: 'Line color'),
          WidgetProperty(name: 'thickness', description: 'Line thickness'),
          WidgetProperty(name: 'indent', description: 'Start padding'),
        ],
      ),

      WidgetModel(
        id: 'sizedbox',
        name: 'SizedBox',
        description: 'A box with specified width and height',
        categoryId: 'basic',
        syntax: '''SizedBox(
  width: 200,
  height: 100,
  child: Container(color: Colors.blue),
)

// For spacing
SizedBox(height: 20)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SizedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Before'),
        SizedBox(height: 30),
        Text('After spacing'),
        SizedBox(width: 200, height: 100, child: Container(color: Colors.blue, child: Center(child: Text('Fixed Size')))),
      ],
    );
  }
}''',
        usage: 'Create fixed-size boxes or add spacing between widgets.',
        properties: [
          WidgetProperty(name: 'width', description: 'Box width'),
          WidgetProperty(name: 'height', description: 'Box height'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'card',
        name: 'Card',
        description: 'Material Design card with elevation',
        categoryId: 'basic',
        syntax: '''Card(
  elevation: 4,
  margin: EdgeInsets.all(8),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card Content'),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.favorite, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text('Card Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Card description goes here'),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Display content in a Material Design card.',
        properties: [
          WidgetProperty(name: 'elevation', description: 'Shadow depth'),
          WidgetProperty(name: 'margin', description: 'Card margin'),
          WidgetProperty(name: 'child', description: 'Card content'),
        ],
      ),

      WidgetModel(
        id: 'circleavatar',
        name: 'CircleAvatar',
        description: 'Circular profile image or icon',
        categoryId: 'basic',
        syntax: '''CircleAvatar(
  radius: 50,
  backgroundImage: NetworkImage('url'),
  child: Text('AB'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CircleAvatarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://picsum.photos/200')),
        CircleAvatar(radius: 40, backgroundColor: Colors.purple, child: Text('JD', style: TextStyle(fontSize: 30, color: Colors.white))),
      ],
    );
  }
}''',
        usage: 'Display circular avatars for profile pictures.',
        properties: [
          WidgetProperty(name: 'radius', description: 'Avatar radius'),
          WidgetProperty(name: 'backgroundImage', description: 'Background image'),
          WidgetProperty(name: 'child', description: 'Child widget (icon/text)'),
        ],
      ),

      WidgetModel(
        id: 'placeholder',
        name: 'Placeholder',
        description: 'Display a placeholder while loading content',
        categoryId: 'basic',
        syntax: '''Placeholder(
  color: Colors.grey,
  strokeWidth: 2,
  fallbackWidth: 200,
  fallbackHeight: 200,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PlaceholderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Placeholder(fallbackWidth: 200, fallbackHeight: 200, color: Colors.blue),
        SizedBox(height: 20),
        Text('Use Placeholder during development'),
      ],
    );
  }
}''',
        usage: 'Show placeholder during development or loading.',
        properties: [
          WidgetProperty(name: 'color', description: 'Placeholder color'),
          WidgetProperty(name: 'fallbackWidth', description: 'Default width'),
          WidgetProperty(name: 'fallbackHeight', description: 'Default height'),
        ],
      ),

      WidgetModel(
        id: 'chip',
        name: 'Chip',
        description: 'Compact element representing attribute, text, or action',
        categoryId: 'basic',
        syntax: '''Chip(
  label: Text('Flutter'),
  avatar: Icon(Icons.code),
  onDeleted: () {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ChipExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        Chip(label: Text('Flutter'), avatar: CircleAvatar(child: Icon(Icons.flutter_dash, size: 16))),
        Chip(label: Text('Dart'), backgroundColor: Colors.blue.shade100),
        Chip(label: Text('Mobile'), onDeleted: () {}, deleteIcon: Icon(Icons.close)),
      ],
    );
  }
}''',
        usage: 'Display tags, filters, or compact information.',
        properties: [
          WidgetProperty(name: 'label', description: 'Chip text'),
          WidgetProperty(name: 'avatar', description: 'Leading icon'),
          WidgetProperty(name: 'onDeleted', description: 'Delete callback'),
        ],
      ),

      WidgetModel(
        id: 'tooltip',
        name: 'Tooltip',
        description: 'Display helpful text on long press',
        categoryId: 'basic',
        syntax: '''Tooltip(
  message: 'This is a helpful hint',
  child: Icon(Icons.info),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TooltipExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Tooltip(message: 'Save', child: Icon(Icons.save, size: 40)),
        Tooltip(message: 'Delete', child: Icon(Icons.delete, size: 40)),
        Tooltip(message: 'Settings', child: Icon(Icons.settings, size: 40)),
      ],
    );
  }
}''',
        usage: 'Add tooltips to provide helpful hints to users.',
        properties: [
          WidgetProperty(name: 'message', description: 'Tooltip text'),
          WidgetProperty(name: 'child', description: 'Widget to show tooltip for'),
        ],
      ),

      WidgetModel(
        id: 'progressindicator',
        name: 'CircularProgressIndicator',
        description: 'Show loading progress in circular form',
        categoryId: 'basic',
        syntax: '''CircularProgressIndicator(
  value: 0.5, // or null for indeterminate
  strokeWidth: 4,
  color: Colors.blue,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ProgressIndicatorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        CircularProgressIndicator(value: 0.7, strokeWidth: 8, color: Colors.green),
        SizedBox(height: 20),
        LinearProgressIndicator(value: 0.5),
      ],
    );
  }
}''',
        usage: 'Display loading or progress state to users.',
        properties: [
          WidgetProperty(name: 'value', description: 'Progress value (0.0-1.0)'),
          WidgetProperty(name: 'strokeWidth', description: 'Indicator thickness'),
          WidgetProperty(name: 'color', description: 'Indicator color'),
        ],
      ),

      WidgetModel(
        id: 'snackbar',
        name: 'SnackBar',
        description: 'Brief message at bottom of screen',
        categoryId: 'basic',
        syntax: '''ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message'),
    action: SnackBarAction(label: 'Undo', onPressed: () {}),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SnackBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item deleted'),
            action: SnackBarAction(label: 'UNDO', onPressed: () {}),
            duration: Duration(seconds: 3),
          ),
        );
      },
      child: Text('Show SnackBar'),
    );
  }
}''',
        usage: 'Show brief messages or action feedback.',
        properties: [
          WidgetProperty(name: 'content', description: 'SnackBar content'),
          WidgetProperty(name: 'action', description: 'Action button'),
          WidgetProperty(name: 'duration', description: 'Display duration'),
        ],
      ),

      // ============= LAYOUT WIDGETS (18) =============
      WidgetModel(
        id: 'column',
        name: 'Column',
        description: 'Arrange children vertically',
        categoryId: 'layout',
        syntax: '''Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Item 1'),
    Text('Item 2'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ColumnExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 100, height: 100, color: Colors.red),
        Container(width: 100, height: 100, color: Colors.green),
        Container(width: 100, height: 100, color: Colors.blue),
      ],
    );
  }
}''',
        usage: 'Layout children in a vertical direction.',
        properties: [
          WidgetProperty(name: 'children', description: 'List of child widgets'),
          WidgetProperty(name: 'mainAxisAlignment', description: 'Vertical alignment'),
          WidgetProperty(name: 'crossAxisAlignment', description: 'Horizontal alignment'),
        ],
      ),

      WidgetModel(
        id: 'row',
        name: 'Row',
        description: 'Arrange children horizontally',
        categoryId: 'layout',
        syntax: '''Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Icon(Icons.star),
    Text('Star'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RowExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.home, size: 50, color: Colors.blue),
        Icon(Icons.favorite, size: 50, color: Colors.red),
        Icon(Icons.settings, size: 50, color: Colors.green),
      ],
    );
  }
}''',
        usage: 'Layout children in a horizontal direction.',
        properties: [
          WidgetProperty(name: 'children', description: 'List of child widgets'),
          WidgetProperty(name: 'mainAxisAlignment', description: 'Horizontal alignment'),
          WidgetProperty(name: 'crossAxisAlignment', description: 'Vertical alignment'),
        ],
      ),

      WidgetModel(
        id: 'stack',
        name: 'Stack',
        description: 'Overlay widgets on top of each other',
        categoryId: 'layout',
        syntax: '''Stack(
  children: [
    Container(color: Colors.blue),
    Positioned(
      top: 10,
      left: 10,
      child: Text('Overlay'),
    ),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class StackExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 300, height: 300, color: Colors.blue),
        Positioned(top: 20, right: 20, child: Icon(Icons.close, color: Colors.white)),
        Center(child: Text('Stacked', style: TextStyle(fontSize: 30, color: Colors.white))),
      ],
    );
  }
}''',
        usage: 'Position widgets on top of each other.',
        properties: [
          WidgetProperty(name: 'children', description: 'List of overlaid widgets'),
          WidgetProperty(name: 'alignment', description: 'How to align children'),
        ],
      ),

      WidgetModel(
        id: 'expanded',
        name: 'Expanded',
        description: 'Expand child to fill available space',
        categoryId: 'layout',
        syntax: '''Row(
  children: [
    Expanded(child: Container(color: Colors.red)),
    Container(width: 50, color: Colors.blue),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ExpandedExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: Container(color: Colors.red, child: Center(child: Text('Flex 2')))),
        Expanded(flex: 1, child: Container(color: Colors.green, child: Center(child: Text('Flex 1')))),
        Expanded(flex: 1, child: Container(color: Colors.blue, child: Center(child: Text('Flex 1')))),
      ],
    );
  }
}''',
        usage: 'Make child widget fill available space in Row/Column.',
        properties: [
          WidgetProperty(name: 'child', description: 'Child widget'),
          WidgetProperty(name: 'flex', description: 'Flex factor'),
        ],
      ),

      WidgetModel(
        id: 'flexible',
        name: 'Flexible',
        description: 'Control how child fits in Row/Column',
        categoryId: 'layout',
        syntax: '''Row(
  children: [
    Flexible(
      fit: FlexFit.loose,
      child: Container(color: Colors.blue),
    ),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FlexibleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 1, child: Container(height: 100, color: Colors.red)),
        Flexible(flex: 2, child: Container(height: 100, color: Colors.green)),
        Flexible(flex: 1, child: Container(height: 100, color: Colors.blue)),
      ],
    );
  }
}''',
        usage: 'Give child flexible space allocation in Row/Column.',
        properties: [
          WidgetProperty(name: 'flex', description: 'Flex factor'),
          WidgetProperty(name: 'fit', description: 'How to fit (tight/loose)'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'padding',
        name: 'Padding',
        description: 'Add padding around a widget',
        categoryId: 'layout',
        syntax: '''Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded text'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PaddingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(20), child: Container(color: Colors.red, child: Text('All 20'))),
        Padding(padding: EdgeInsets.symmetric(horizontal: 40), child: Container(color: Colors.green, child: Text('Horizontal 40'))),
        Padding(padding: EdgeInsets.only(left: 60), child: Container(color: Colors.blue, child: Text('Left 60'))),
      ],
    );
  }
}''',
        usage: 'Add inner spacing around widgets.',
        properties: [
          WidgetProperty(name: 'padding', description: 'Padding values'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'center',
        name: 'Center',
        description: 'Center child within parent',
        categoryId: 'layout',
        syntax: '''Center(
  child: Text('Centered'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CenterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      width: 300,
      height: 300,
      child: Center(
        child: Container(width: 100, height: 100, color: Colors.red, child: Center(child: Text('Centered'))),
      ),
    );
  }
}''',
        usage: 'Center child widget within available space.',
        properties: [
          WidgetProperty(name: 'child', description: 'Widget to center'),
        ],
      ),

      WidgetModel(
        id: 'align',
        name: 'Align',
        description: 'Align child within parent',
        categoryId: 'layout',
        syntax: '''Align(
  alignment: Alignment.topRight,
  child: Text('Aligned'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AlignExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.grey.shade200,
      child: Stack(
        children: [
          Align(alignment: Alignment.topLeft, child: Container(width: 50, height: 50, color: Colors.red)),
          Align(alignment: Alignment.topRight, child: Container(width: 50, height: 50, color: Colors.blue)),
          Align(alignment: Alignment.bottomLeft, child: Container(width: 50, height: 50, color: Colors.green)),
          Align(alignment: Alignment.bottomRight, child: Container(width: 50, height: 50, color: Colors.orange)),
        ],
      ),
    );
  }
}''',
        usage: 'Align child to specific position within parent.',
        properties: [
          WidgetProperty(name: 'alignment', description: 'Alignment position'),
          WidgetProperty(name: 'child', description: 'Widget to align'),
        ],
      ),

      WidgetModel(
        id: 'positioned',
        name: 'Positioned',
        description: 'Position child within Stack',
        categoryId: 'layout',
        syntax: '''Stack(
  children: [
    Positioned(
      top: 10,
      left: 20,
      child: Text('Positioned'),
    ),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PositionedExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(width: 300, height: 300, color: Colors.grey.shade300),
        Positioned(top: 10, left: 10, child: Container(width: 50, height: 50, color: Colors.red)),
        Positioned(top: 10, right: 10, child: Container(width: 50, height: 50, color: Colors.blue)),
        Positioned(bottom: 10, left: 10, child: Container(width: 50, height: 50, color: Colors.green)),
        Positioned(bottom: 10, right: 10, child: Container(width: 50, height: 50, color: Colors.orange)),
      ],
    );
  }
}''',
        usage: 'Precisely position widgets within a Stack.',
        properties: [
          WidgetProperty(name: 'top', description: 'Distance from top'),
          WidgetProperty(name: 'left', description: 'Distance from left'),
          WidgetProperty(name: 'right', description: 'Distance from right'),
          WidgetProperty(name: 'bottom', description: 'Distance from bottom'),
        ],
      ),

      WidgetModel(
        id: 'wrap',
        name: 'Wrap',
        description: 'Layout children with wrapping',
        categoryId: 'layout',
        syntax: '''Wrap(
  spacing: 8,
  runSpacing: 4,
  children: [
    Chip(label: Text('Tag 1')),
    Chip(label: Text('Tag 2')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class WrapExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(15, (i) => 
        Chip(label: Text('Item \${i + 1}'), backgroundColor: Colors.primaries[i % Colors.primaries.length].shade100)
      ),
    );
  }
}''',
        usage: 'Layout children with automatic wrapping to next line.',
        properties: [
          WidgetProperty(name: 'spacing', description: 'Horizontal spacing'),
          WidgetProperty(name: 'runSpacing', description: 'Vertical spacing'),
          WidgetProperty(name: 'children', description: 'Child widgets'),
        ],
      ),

      WidgetModel(
        id: 'aspectratio',
        name: 'AspectRatio',
        description: 'Size child to specific aspect ratio',
        categoryId: 'layout',
        syntax: '''AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(color: Colors.blue),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AspectRatioExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(aspectRatio: 16 / 9, child: Container(color: Colors.red, child: Center(child: Text('16:9')))),
        SizedBox(height: 10),
        AspectRatio(aspectRatio: 4 / 3, child: Container(color: Colors.green, child: Center(child: Text('4:3')))),
        SizedBox(height: 10),
        AspectRatio(aspectRatio: 1, child: Container(color: Colors.blue, child: Center(child: Text('1:1')))),
      ],
    );
  }
}''',
        usage: 'Maintain specific aspect ratio for child widget.',
        properties: [
          WidgetProperty(name: 'aspectRatio', description: 'Aspect ratio (width/height)'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'fractionallysizedbox',
        name: 'FractionallySizedBox',
        description: 'Size child as fraction of parent',
        categoryId: 'layout',
        syntax: '''FractionallySizedBox(
  widthFactor: 0.5,
  heightFactor: 0.3,
  child: Container(color: Colors.blue),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FractionallySizedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(color: Colors.grey.shade200, height: 100, child: FractionallySizedBox(widthFactor: 0.5, child: Container(color: Colors.red, child: Center(child: Text('50% width'))))),
        SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 100, child: FractionallySizedBox(widthFactor: 0.8, child: Container(color: Colors.blue, child: Center(child: Text('80% width'))))),
      ],
    );
  }
}''',
        usage: 'Size widget as percentage of parent size.',
        properties: [
          WidgetProperty(name: 'widthFactor', description: 'Width as fraction (0.0-1.0)'),
          WidgetProperty(name: 'heightFactor', description: 'Height as fraction (0.0-1.0)'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'constrainedbox',
        name: 'ConstrainedBox',
        description: 'Impose constraints on child',
        categoryId: 'layout',
        syntax: '''ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: 100,
    maxWidth: 200,
  ),
  child: Container(color: Colors.blue),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ConstrainedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(constraints: BoxConstraints(minWidth: 200, minHeight: 100), child: Container(color: Colors.red, child: Center(child: Text('Min 200x100')))),
        SizedBox(height: 10),
        ConstrainedBox(constraints: BoxConstraints(maxWidth: 150), child: Container(color: Colors.blue, child: Text('Max width 150: This text will wrap because of the constraint'))),
      ],
    );
  }
}''',
        usage: 'Apply size constraints to child widget.',
        properties: [
          WidgetProperty(name: 'constraints', description: 'BoxConstraints to apply'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'fittedbox',
        name: 'FittedBox',
        description: 'Scale and position child within parent',
        categoryId: 'layout',
        syntax: '''FittedBox(
  fit: BoxFit.contain,
  child: Text('Scaled Text'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FittedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 100, height: 100, color: Colors.red.shade100, child: FittedBox(child: Text('Fit', style: TextStyle(fontSize: 50)))),
        Container(width: 100, height: 100, color: Colors.blue.shade100, child: FittedBox(child: Icon(Icons.star, size: 200))),
      ],
    );
  }
}''',
        usage: 'Scale child to fit parent while maintaining aspect ratio.',
        properties: [
          WidgetProperty(name: 'fit', description: 'How to fit (contain/cover/fill)'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'limitedbox',
        name: 'LimitedBox',
        description: 'Limit size when unconstrained',
        categoryId: 'layout',
        syntax: '''LimitedBox(
  maxWidth: 200,
  maxHeight: 100,
  child: Container(color: Colors.blue),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class LimitedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LimitedBox(maxHeight: 100, child: Container(color: Colors.red, child: Center(child: Text('Limited to 100')))),
        LimitedBox(maxHeight: 150, child: Container(color: Colors.green, child: Center(child: Text('Limited to 150')))),
        LimitedBox(maxHeight: 200, child: Container(color: Colors.blue, child: Center(child: Text('Limited to 200')))),
      ],
    );
  }
}''',
        usage: 'Set maximum size when widget is unconstrained.',
        properties: [
          WidgetProperty(name: 'maxWidth', description: 'Maximum width'),
          WidgetProperty(name: 'maxHeight', description: 'Maximum height'),
        ],
      ),

      WidgetModel(
        id: 'baseline',
        name: 'Baseline',
        description: 'Position child according to baseline',
        categoryId: 'layout',
        syntax: '''Baseline(
  baseline: 50,
  baselineType: TextBaseline.alphabetic,
  child: Text('Text'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class BaselineExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('Small', style: TextStyle(fontSize: 20)),
        Text('Medium', style: TextStyle(fontSize: 30)),
        Text('Large', style: TextStyle(fontSize: 40)),
      ],
    );
  }
}''',
        usage: 'Align widgets based on text baseline.',
        properties: [
          WidgetProperty(name: 'baseline', description: 'Baseline position'),
          WidgetProperty(name: 'baselineType', description: 'Baseline type'),
        ],
      ),

      WidgetModel(
        id: 'spacer',
        name: 'Spacer',
        description: 'Create flexible empty space',
        categoryId: 'layout',
        syntax: '''Row(
  children: [
    Text('Start'),
    Spacer(),
    Text('End'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SpacerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Icon(Icons.star), Spacer(), Text('Far Apart'), Spacer(), Icon(Icons.star)]),
        SizedBox(height: 20),
        Row(children: [Text('Left'), Spacer(flex: 2), Text('Middle'), Spacer(flex: 1), Text('Right')]),
      ],
    );
  }
}''',
        usage: 'Add flexible empty space in Row or Column.',
        properties: [
          WidgetProperty(name: 'flex', description: 'Flex factor (default 1)'),
        ],
      ),

      WidgetModel(
        id: 'overflowbox',
        name: 'OverflowBox',
        description: 'Impose different constraints on child',
        categoryId: 'layout',
        syntax: '''OverflowBox(
  maxWidth: 300,
  maxHeight: 300,
  child: Container(width: 400, height: 400),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class OverflowBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade300,
      child: OverflowBox(
        maxWidth: 200,
        maxHeight: 200,
        child: Container(width: 150, height: 150, color: Colors.red.withOpacity(0.7), child: Center(child: Text('Overflow'))),
      ),
    );
  }
}''',
        usage: 'Allow child to overflow parent constraints.',
        properties: [
          WidgetProperty(name: 'maxWidth', description: 'Maximum width'),
          WidgetProperty(name: 'maxHeight', description: 'Maximum height'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      // ============= INPUT WIDGETS (10) =============
      WidgetModel(
        id: 'textfield',
        name: 'TextField',
        description: 'Text input field',
        categoryId: 'input',
        syntax: '''TextField(
  decoration: InputDecoration(
    labelText: 'Enter name',
    hintText: 'John Doe',
    border: OutlineInputBorder(),
  ),
  onChanged: (value) {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TextFieldExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Accept text input from users.',
        properties: [
          WidgetProperty(name: 'decoration', description: 'Visual decoration'),
          WidgetProperty(name: 'onChanged', description: 'Value change callback'),
          WidgetProperty(name: 'controller', description: 'Text controller'),
        ],
      ),

      WidgetModel(
        id: 'checkbox',
        name: 'Checkbox',
        description: 'Checkbox for boolean selection',
        categoryId: 'input',
        syntax: '''Checkbox(
  value: isChecked,
  onChanged: (bool? value) {
    setState(() => isChecked = value!);
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CheckboxExample extends StatefulWidget {
  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool check1 = false, check2 = true, check3 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(title: Text('Option 1'), value: check1, onChanged: (v) => setState(() => check1 = v!)),
        CheckboxListTile(title: Text('Option 2'), value: check2, onChanged: (v) => setState(() => check2 = v!)),
        CheckboxListTile(title: Text('Option 3'), value: check3, onChanged: (v) => setState(() => check3 = v!)),
      ],
    );
  }
}''',
        usage: 'Select true/false options with checkboxes.',
        properties: [
          WidgetProperty(name: 'value', description: 'Current value'),
          WidgetProperty(name: 'onChanged', description: 'Change callback'),
        ],
      ),

      WidgetModel(
        id: 'radio',
        name: 'Radio',
        description: 'Radio button for single selection',
        categoryId: 'input',
        syntax: '''Radio<int>(
  value: 1,
  groupValue: selectedValue,
  onChanged: (int? value) {
    setState(() => selectedValue = value);
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RadioExample extends StatefulWidget {
  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(title: Text('Option 1'), value: 1, groupValue: selected, onChanged: (v) => setState(() => selected = v!)),
        RadioListTile(title: Text('Option 2'), value: 2, groupValue: selected, onChanged: (v) => setState(() => selected = v!)),
        RadioListTile(title: Text('Option 3'), value: 3, groupValue: selected, onChanged: (v) => setState(() => selected = v!)),
      ],
    );
  }
}''',
        usage: 'Select one option from multiple choices.',
        properties: [
          WidgetProperty(name: 'value', description: 'Option value'),
          WidgetProperty(name: 'groupValue', description: 'Selected value'),
          WidgetProperty(name: 'onChanged', description: 'Change callback'),
        ],
      ),

      WidgetModel(
        id: 'switch',
        name: 'Switch',
        description: 'Toggle switch for on/off',
        categoryId: 'input',
        syntax: '''Switch(
  value: isOn,
  onChanged: (bool value) {
    setState(() => isOn = value);
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SwitchExample extends StatefulWidget {
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool switch1 = false, switch2 = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(title: Text('Notifications'), value: switch1, onChanged: (v) => setState(() => switch1 = v)),
        SwitchListTile(title: Text('Dark Mode'), value: switch2, onChanged: (v) => setState(() => switch2 = v)),
      ],
    );
  }
}''',
        usage: 'Toggle between on and off states.',
        properties: [
          WidgetProperty(name: 'value', description: 'Current state'),
          WidgetProperty(name: 'onChanged', description: 'Change callback'),
        ],
      ),

      WidgetModel(
        id: 'slider',
        name: 'Slider',
        description: 'Slider for selecting from range',
        categoryId: 'input',
        syntax: '''Slider(
  value: currentValue,
  min: 0,
  max: 100,
  divisions: 10,
  label: currentValue.round().toString(),
  onChanged: (double value) {
    setState(() => currentValue = value);
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SliderExample extends StatefulWidget {
  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double value = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Value: \${value.round()}', style: TextStyle(fontSize: 24)),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 20,
          label: value.round().toString(),
          onChanged: (v) => setState(() => value = v),
        ),
      ],
    );
  }
}''',
        usage: 'Select value from continuous or discrete range.',
        properties: [
          WidgetProperty(name: 'value', description: 'Current value'),
          WidgetProperty(name: 'min', description: 'Minimum value'),
          WidgetProperty(name: 'max', description: 'Maximum value'),
          WidgetProperty(name: 'onChanged', description: 'Change callback'),
        ],
      ),

      WidgetModel(
        id: 'dropdownbutton',
        name: 'DropdownButton',
        description: 'Dropdown selection menu',
        categoryId: 'input',
        syntax: '''DropdownButton<String>(
  value: selectedItem,
  items: items.map((String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: Text(item),
    );
  }).toList(),
  onChanged: (String? value) {
    setState(() => selectedItem = value!);
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String selected = 'Flutter';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      items: ['Flutter', 'Dart', 'Android', 'iOS', 'Web'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (v) => setState(() => selected = v!),
    );
  }
}''',
        usage: 'Display dropdown menu for selection.',
        properties: [
          WidgetProperty(name: 'value', description: 'Selected value'),
          WidgetProperty(name: 'items', description: 'Dropdown items'),
          WidgetProperty(name: 'onChanged', description: 'Selection callback'),
        ],
      ),

      WidgetModel(
        id: 'form',
        name: 'Form',
        description: 'Container for form fields with validation',
        categoryId: 'input',
        syntax: '''Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(validator: (v) => v!.isEmpty ? 'Required' : null),
    ],
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FormExample extends StatefulWidget {
  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(decoration: InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
          TextFormField(decoration: InputDecoration(labelText: 'Email'), validator: (v) => v!.contains('@') ? null : 'Invalid email'),
          ElevatedButton(onPressed: () { if (_formKey.currentState!.validate()) {} }, child: Text('Submit')),
        ],
      ),
    );
  }
}''',
        usage: 'Group and validate form input fields.',
        properties: [
          WidgetProperty(name: 'key', description: 'Form key for validation'),
          WidgetProperty(name: 'child', description: 'Form content'),
        ],
      ),

      WidgetModel(
        id: 'datepicker',
        name: 'DatePicker',
        description: 'Select date from calendar',
        categoryId: 'input',
        syntax: '''showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DatePickerExample extends StatefulWidget {
  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(selectedDate == null ? 'No date selected' : 'Selected: \${selectedDate!.toLocal()}'.split(' ')[0]),
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (date != null) setState(() => selectedDate = date);
          },
          child: Text('Pick Date'),
        ),
      ],
    );
  }
}''',
        usage: 'Show date picker dialog for date selection.',
        properties: [
          WidgetProperty(name: 'initialDate', description: 'Initial date'),
          WidgetProperty(name: 'firstDate', description: 'Earliest date'),
          WidgetProperty(name: 'lastDate', description: 'Latest date'),
        ],
      ),

      WidgetModel(
        id: 'timepicker',
        name: 'TimePicker',
        description: 'Select time from clock',
        categoryId: 'input',
        syntax: '''showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TimePickerExample extends StatefulWidget {
  @override
  State<TimePickerExample> createState() => _TimePickerExampleState();
}

class _TimePickerExampleState extends State<TimePickerExample> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(selectedTime == null ? 'No time selected' : 'Selected: \${selectedTime!.format(context)}'),
        ElevatedButton(
          onPressed: () async {
            final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (time != null) setState(() => selectedTime = time);
          },
          child: Text('Pick Time'),
        ),
      ],
    );
  }
}''',
        usage: 'Show time picker dialog for time selection.',
        properties: [
          WidgetProperty(name: 'initialTime', description: 'Initial time'),
        ],
      ),

      WidgetModel(
        id: 'autocomplete',
        name: 'Autocomplete',
        description: 'TextField with autocomplete suggestions',
        categoryId: 'input',
        syntax: '''Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    return options.where((option) =>
      option.toLowerCase().contains(textEditingValue.text.toLowerCase())
    );
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AutocompleteExample extends StatelessWidget {
  static const List<String> _options = ['Flutter', 'Dart', 'Android', 'iOS', 'Web', 'Desktop'];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') return const Iterable<String>.empty();
        return _options.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {},
    );
  }
}''',
        usage: 'Provide autocomplete suggestions as user types.',
        properties: [
          WidgetProperty(name: 'optionsBuilder', description: 'Build suggestions'),
          WidgetProperty(name: 'onSelected', description: 'Selection callback'),
        ],
      ),

      // ============= BUTTON WIDGETS (10) =============
      WidgetModel(
        id: 'elevatedbutton',
        name: 'ElevatedButton',
        description: 'Material Design raised button',
        categoryId: 'button',
        syntax: '''ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ElevatedButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, child: Text('Normal Button')),
        ElevatedButton(onPressed: null, child: Text('Disabled Button')),
        ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.send), label: Text('Send')),
      ],
    );
  }
}''',
        usage: 'Display material design raised button.',
        properties: [
          WidgetProperty(name: 'onPressed', description: 'Press callback'),
          WidgetProperty(name: 'child', description: 'Button content'),
        ],
      ),

      WidgetModel(
        id: 'textbutton',
        name: 'TextButton',
        description: 'Flat text button without elevation',
        categoryId: 'button',
        syntax: '''TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TextButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: () {}, child: Text('Cancel')),
        TextButton.icon(onPressed: () {}, icon: Icon(Icons.download), label: Text('Download')),
      ],
    );
  }
}''',
        usage: 'Display flat text button for secondary actions.',
        properties: [
          WidgetProperty(name: 'onPressed', description: 'Press callback'),
          WidgetProperty(name: 'child', description: 'Button text'),
        ],
      ),

      WidgetModel(
        id: 'outlinedbutton',
        name: 'OutlinedButton',
        description: 'Button with border outline',
        categoryId: 'button',
        syntax: '''OutlinedButton(
  onPressed: () {},
  child: Text('Outlined'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class OutlinedButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(onPressed: () {}, child: Text('Outlined Button')),
        OutlinedButton.icon(onPressed: () {}, icon: Icon(Icons.add), label: Text('Add')),
      ],
    );
  }
}''',
        usage: 'Display button with outline border.',
        properties: [
          WidgetProperty(name: 'onPressed', description: 'Press callback'),
          WidgetProperty(name: 'child', description: 'Button content'),
        ],
      ),

      WidgetModel(
        id: 'iconbutton',
        name: 'IconButton',
        description: 'Button with icon',
        categoryId: 'button',
        syntax: '''IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class IconButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}, iconSize: 40, color: Colors.blue),
        IconButton(icon: Icon(Icons.favorite), onPressed: () {}, iconSize: 40, color: Colors.red),
        IconButton(icon: Icon(Icons.share), onPressed: () {}, iconSize: 40, color: Colors.green),
      ],
    );
  }
}''',
        usage: 'Display icon as clickable button.',
        properties: [
          WidgetProperty(name: 'icon', description: 'Icon to display'),
          WidgetProperty(name: 'onPressed', description: 'Press callback'),
        ],
      ),

      WidgetModel(
        id: 'floatingactionbutton',
        name: 'FloatingActionButton',
        description: 'Circular floating action button',
        categoryId: 'button',
        syntax: '''FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FloatingActionButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
          SizedBox(height: 16),
          FloatingActionButton.extended(onPressed: () {}, icon: Icon(Icons.edit), label: Text('Edit')),
        ],
      ),
    );
  }
}''',
        usage: 'Display primary action button floating above content.',
        properties: [
          WidgetProperty(name: 'onPressed', description: 'Press callback'),
          WidgetProperty(name: 'child', description: 'FAB icon'),
        ],
      ),

      WidgetModel(
        id: 'popupmenubutton',
        name: 'PopupMenuButton',
        description: 'Button that shows popup menu',
        categoryId: 'button',
        syntax: '''PopupMenuButton<String>(
  itemBuilder: (context) => [
    PopupMenuItem(value: 'Option 1', child: Text('Option 1')),
  ],
  onSelected: (value) {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PopupMenuButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')])),
        PopupMenuItem(value: 'share', child: Row(children: [Icon(Icons.share), SizedBox(width: 8), Text('Share')])),
        PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete), SizedBox(width: 8), Text('Delete')])),
      ],
      onSelected: (value) => print(value),
    );
  }
}''',
        usage: 'Show popup menu with multiple options.',
        properties: [
          WidgetProperty(name: 'itemBuilder', description: 'Build menu items'),
          WidgetProperty(name: 'onSelected', description: 'Selection callback'),
        ],
      ),

      WidgetModel(
        id: 'dropdownbutton',
        name: 'DropdownButton',
        description: 'Dropdown selection button',
        categoryId: 'button',
        syntax: '''DropdownButton<String>(
  value: selectedValue,
  items: items.map((item) =>
    DropdownMenuItem(value: item, child: Text(item))
  ).toList(),
  onChanged: (value) {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: <String>['One', 'Two', 'Three', 'Four'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) => setState(() => dropdownValue = newValue!),
    );
  }
}''',
        usage: 'Display dropdown menu for selection.',
        properties: [
          WidgetProperty(name: 'value', description: 'Selected value'),
          WidgetProperty(name: 'items', description: 'Dropdown items'),
          WidgetProperty(name: 'onChanged', description: 'Selection callback'),
        ],
      ),

      WidgetModel(
        id: 'inkwell',
        name: 'InkWell',
        description: 'Make any widget tappable with ripple effect',
        categoryId: 'button',
        syntax: '''InkWell(
  onTap: () {},
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text('Tap me'),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class InkWellExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(padding: EdgeInsets.all(20), child: Text('Tap for ripple')),
        ),
        InkWell(
          onTap: () {},
          onLongPress: () {},
          child: Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.blue.shade100), child: Text('Tap or Long Press')),
        ),
      ],
    );
  }
}''',
        usage: 'Add touch ripple effect to any widget.',
        properties: [
          WidgetProperty(name: 'onTap', description: 'Tap callback'),
          WidgetProperty(name: 'child', description: 'Widget to make tappable'),
        ],
      ),

      WidgetModel(
        id: 'gesturedetector',
        name: 'GestureDetector',
        description: 'Detect gestures on child widget',
        categoryId: 'button',
        syntax: '''GestureDetector(
  onTap: () {},
  onDoubleTap: () {},
  onLongPress: () {},
  child: Container(child: Text('Gestures')),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class GestureDetectorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Tap'),
      onDoubleTap: () => print('Double Tap'),
      onLongPress: () => print('Long Press'),
      child: Container(
        padding: EdgeInsets.all(30),
        color: Colors.blue.shade100,
        child: Text('Tap, Double Tap, or Long Press me'),
      ),
    );
  }
}''',
        usage: 'Detect various touch gestures on widgets.',
        properties: [
          WidgetProperty(name: 'onTap', description: 'Tap callback'),
          WidgetProperty(name: 'onDoubleTap', description: 'Double tap callback'),
          WidgetProperty(name: 'onLongPress', description: 'Long press callback'),
        ],
      ),

      WidgetModel(
        id: 'segmentedbutton',
        name: 'SegmentedButton',
        description: 'Horizontal segmented button group',
        categoryId: 'button',
        syntax: '''SegmentedButton<String>(
  segments: [
    ButtonSegment(value: '1', label: Text('Option 1')),
    ButtonSegment(value: '2', label: Text('Option 2')),
  ],
  selected: {'1'},
  onSelectionChanged: (Set<String> newSelection) {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SegmentedButtonExample extends StatefulWidget {
  @override
  State<SegmentedButtonExample> createState() => _SegmentedButtonExampleState();
}

class _SegmentedButtonExampleState extends State<SegmentedButtonExample> {
  Set<String> selected = {'day'};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(value: 'day', label: Text('Day'), icon: Icon(Icons.wb_sunny)),
        ButtonSegment(value: 'week', label: Text('Week'), icon: Icon(Icons.calendar_view_week)),
        ButtonSegment(value: 'month', label: Text('Month'), icon: Icon(Icons.calendar_month)),
      ],
      selected: selected,
      onSelectionChanged: (newSelection) => setState(() => selected = newSelection),
    );
  }
}''',
        usage: 'Display group of related buttons as segments.',
        properties: [
          WidgetProperty(name: 'segments', description: 'Button segments'),
          WidgetProperty(name: 'selected', description: 'Selected values'),
          WidgetProperty(name: 'onSelectionChanged', description: 'Selection callback'),
        ],
      ),

      // ============= LIST & DISPLAY WIDGETS (12) =============
      WidgetModel(
        id: 'listview',
        name: 'ListView',
        description: 'Scrollable list of widgets',
        categoryId: 'list',
        syntax: '''ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
  ],
)

ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(child: Text('\${index + 1}')),
        title: Text('Item \${index + 1}'),
        subtitle: Text('Subtitle \${index + 1}'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}''',
        usage: 'Display scrollable list of items.',
        properties: [
          WidgetProperty(name: 'children', description: 'List items'),
          WidgetProperty(name: 'itemCount', description: 'Number of items'),
          WidgetProperty(name: 'itemBuilder', description: 'Builder function'),
        ],
      ),

      WidgetModel(
        id: 'gridview',
        name: 'GridView',
        description: 'Scrollable 2D grid of widgets',
        categoryId: 'list',
        syntax: '''GridView.count(
  crossAxisCount: 2,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class GridViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 30,
      itemBuilder: (context, index) => Container(
        color: Colors.primaries[index % Colors.primaries.length],
        child: Center(child: Text('\${index + 1}', style: TextStyle(color: Colors.white, fontSize: 20))),
      ),
    );
  }
}''',
        usage: 'Display scrollable grid of items.',
        properties: [
          WidgetProperty(name: 'crossAxisCount', description: 'Number of columns'),
          WidgetProperty(name: 'children', description: 'Grid items'),
        ],
      ),

      WidgetModel(
        id: 'listtile',
        name: 'ListTile',
        description: 'Single fixed-height row containing text and icons',
        categoryId: 'list',
        syntax: '''ListTile(
  leading: Icon(Icons.person),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  trailing: Icon(Icons.arrow_forward),
  onTap: () {},
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ListTileExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () {}),
        ListTile(leading: Icon(Icons.favorite), title: Text('Favorites'), trailing: Chip(label: Text('5')), onTap: () {}),
        ListTile(leading: Icon(Icons.settings), title: Text('Settings'), subtitle: Text('App settings'), onTap: () {}),
      ],
    );
  }
}''',
        usage: 'Display list item with leading/trailing widgets.',
        properties: [
          WidgetProperty(name: 'leading', description: 'Leading widget'),
          WidgetProperty(name: 'title', description: 'Title text'),
          WidgetProperty(name: 'subtitle', description: 'Subtitle text'),
          WidgetProperty(name: 'trailing', description: 'Trailing widget'),
        ],
      ),

      WidgetModel(
        id: 'expansiontile',
        name: 'ExpansionTile',
        description: 'Expandable list item',
        categoryId: 'list',
        syntax: '''ExpansionTile(
  title: Text('Title'),
  children: [
    ListTile(title: Text('Child 1')),
    ListTile(title: Text('Child 2')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ExpansionTileExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Category 1'),
          leading: Icon(Icons.folder),
          children: [ListTile(title: Text('Item 1.1')), ListTile(title: Text('Item 1.2'))],
        ),
        ExpansionTile(
          title: Text('Category 2'),
          leading: Icon(Icons.folder),
          children: [ListTile(title: Text('Item 2.1')), ListTile(title: Text('Item 2.2')), ListTile(title: Text('Item 2.3'))],
        ),
      ],
    );
  }
}''',
        usage: 'Create expandable/collapsible list items.',
        properties: [
          WidgetProperty(name: 'title', description: 'Tile title'),
          WidgetProperty(name: 'children', description: 'Expanded children'),
        ],
      ),

      WidgetModel(
        id: 'dataTable',
        name: 'DataTable',
        description: 'Material Design data table',
        categoryId: 'list',
        syntax: '''DataTable(
  columns: [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Age')),
  ],
  rows: [
    DataRow(cells: [
      DataCell(Text('John')),
      DataCell(Text('25')),
    ]),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DataTableExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Age')),
          DataColumn(label: Text('Role')),
        ],
        rows: [
          DataRow(cells: [DataCell(Text('John')), DataCell(Text('25')), DataCell(Text('Developer'))]),
          DataRow(cells: [DataCell(Text('Jane')), DataCell(Text('30')), DataCell(Text('Designer'))]),
          DataRow(cells: [DataCell(Text('Bob')), DataCell(Text('35')), DataCell(Text('Manager'))]),
        ],
      ),
    );
  }
}''',
        usage: 'Display structured data in table format.',
        properties: [
          WidgetProperty(name: 'columns', description: 'Table columns'),
          WidgetProperty(name: 'rows', description: 'Table rows'),
        ],
      ),

      WidgetModel(
        id: 'reorderablelistview',
        name: 'ReorderableListView',
        description: 'List that allows drag-to-reorder',
        categoryId: 'list',
        syntax: '''ReorderableListView(
  onReorder: (oldIndex, newIndex) {},
  children: [
    ListTile(key: ValueKey(1), title: Text('Item 1')),
    ListTile(key: ValueKey(2), title: Text('Item 2')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ReorderableListViewExample extends StatefulWidget {
  @override
  State<ReorderableListViewExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableListViewExample> {
  List<int> items = List.generate(10, (i) => i);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: items.map((item) => ListTile(key: ValueKey(item), leading: Icon(Icons.drag_handle), title: Text('Item \$item'))).toList(),
    );
  }
}''',
        usage: 'Create list with drag-to-reorder functionality.',
        properties: [
          WidgetProperty(name: 'onReorder', description: 'Reorder callback'),
          WidgetProperty(name: 'children', description: 'List items (must have keys)'),
        ],
      ),

      WidgetModel(
        id: 'singlechildscrollview',
        name: 'SingleChildScrollView',
        description: 'Make any widget scrollable',
        categoryId: 'list',
        syntax: '''SingleChildScrollView(
  child: Column(
    children: [/* many children */],
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SingleChildScrollViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(20, (i) => Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(20),
          color: Colors.primaries[i % Colors.primaries.length].shade200,
          child: Text('Item \${i + 1}', style: TextStyle(fontSize: 20)),
        )),
      ),
    );
  }
}''',
        usage: 'Make single child widget scrollable.',
        properties: [
          WidgetProperty(name: 'child', description: 'Scrollable child'),
          WidgetProperty(name: 'scrollDirection', description: 'Scroll direction'),
        ],
      ),

      WidgetModel(
        id: 'pageview',
        name: 'PageView',
        description: 'Swipeable pages view',
        categoryId: 'list',
        syntax: '''PageView(
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PageViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Container(color: Colors.red, child: Center(child: Text('Page 1', style: TextStyle(fontSize: 40, color: Colors.white)))),
        Container(color: Colors.green, child: Center(child: Text('Page 2', style: TextStyle(fontSize: 40, color: Colors.white)))),
        Container(color: Colors.blue, child: Center(child: Text('Page 3', style: TextStyle(fontSize: 40, color: Colors.white)))),
      ],
    );
  }
}''',
        usage: 'Create swipeable page view.',
        properties: [
          WidgetProperty(name: 'children', description: 'Pages to display'),
          WidgetProperty(name: 'scrollDirection', description: 'Scroll direction'),
        ],
      ),

      WidgetModel(
        id: 'refreshindicator',
        name: 'RefreshIndicator',
        description: 'Pull-to-refresh functionality',
        categoryId: 'list',
        syntax: '''RefreshIndicator(
  onRefresh: () async {
    // Refresh logic
  },
  child: ListView(...),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RefreshIndicatorExample extends StatefulWidget {
  @override
  State<RefreshIndicatorExample> createState() => _RefreshIndicatorExampleState();
}

class _RefreshIndicatorExampleState extends State<RefreshIndicatorExample> {
  List<int> items = List.generate(20, (i) => i);

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() => items = List.generate(20, (i) => i));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(itemCount: items.length, itemBuilder: (context, i) => ListTile(title: Text('Item \${items[i]}'))),
    );
  }
}''',
        usage: 'Add pull-to-refresh to scrollable widgets.',
        properties: [
          WidgetProperty(name: 'onRefresh', description: 'Refresh callback'),
          WidgetProperty(name: 'child', description: 'Scrollable widget'),
        ],
      ),

      WidgetModel(
        id: 'animatedlist',
        name: 'AnimatedList',
        description: 'List with animated insertions and removals',
        categoryId: 'list',
        syntax: '''AnimatedList(
  key: listKey,
  initialItemCount: items.length,
  itemBuilder: (context, index, animation) {
    return SlideTransition(
      position: animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero)),
      child: ListTile(title: Text(items[index])),
    );
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedListExample extends StatefulWidget {
  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<int> _items = [0, 1, 2];

  void _addItem() {
    final index = _items.length;
    _items.add(index);
    _listKey.currentState!.insertItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _addItem, child: Text('Add Item')),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) => SlideTransition(
              position: animation.drive(Tween(begin: Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut))),
              child: ListTile(title: Text('Item \${_items[index]}')),
            ),
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Create list with animated item changes.',
        properties: [
          WidgetProperty(name: 'initialItemCount', description: 'Initial number of items'),
          WidgetProperty(name: 'itemBuilder', description: 'Build animated items'),
        ],
      ),

      WidgetModel(
        id: 'customscrollview',
        name: 'CustomScrollView',
        description: 'Create custom scroll effects using slivers',
        categoryId: 'list',
        syntax: '''CustomScrollView(
  slivers: [
    SliverAppBar(title: Text('Title')),
    SliverList(delegate: SliverChildBuilderDelegate(...)),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CustomScrollViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text('Custom Scroll'), floating: true, expandedHeight: 200),
        SliverList(delegate: SliverChildBuilderDelegate((context, index) => ListTile(title: Text('Item \$index')), childCount: 50)),
      ],
    );
  }
}''',
        usage: 'Build complex scrollable layouts with slivers.',
        properties: [
          WidgetProperty(name: 'slivers', description: 'List of sliver widgets'),
        ],
      ),

      WidgetModel(
        id: 'scrollbar',
        name: 'Scrollbar',
        description: 'Add scrollbar to scrollable widget',
        categoryId: 'list',
        syntax: '''Scrollbar(
  child: ListView(...),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ScrollbarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 8,
      thumbVisibility: true,
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(title: Text('Item \$index')),
      ),
    );
  }
}''',
        usage: 'Add visible scrollbar to scrollable content.',
        properties: [
          WidgetProperty(name: 'child', description: 'Scrollable widget'),
          WidgetProperty(name: 'thickness', description: 'Scrollbar thickness'),
        ],
      ),

      // ============= NAVIGATION WIDGETS (10) =============
      WidgetModel(
        id: 'bottomnavigationbar',
        name: 'BottomNavigationBar',
        description: 'Bottom navigation bar with multiple tabs',
        categoryId: 'navigation',
        syntax: '''BottomNavigationBar(
  currentIndex: selectedIndex,
  onTap: (index) => setState(() => selectedIndex = index),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class BottomNavigationBarExample extends StatefulWidget {
  @override
  State<BottomNavigationBarExample> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page \$_selectedIndex')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}''',
        usage: 'Add bottom navigation bar to switch between pages.',
        properties: [
          WidgetProperty(name: 'currentIndex', description: 'Selected tab index'),
          WidgetProperty(name: 'onTap', description: 'Tab selection callback'),
          WidgetProperty(name: 'items', description: 'Navigation items'),
        ],
      ),

      WidgetModel(
        id: 'tabbar',
        name: 'TabBar',
        description: 'Tab bar for switching between pages',
        categoryId: 'navigation',
        syntax: '''DefaultTabController(
  length: 3,
  child: Column(
    children: [
      TabBar(tabs: [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')]),
      Expanded(child: TabBarView(children: [/* pages */])),
    ],
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TabBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TabBar Example'),
          bottom: TabBar(tabs: [Tab(icon: Icon(Icons.home), text: 'Home'), Tab(icon: Icon(Icons.star), text: 'Favorites'), Tab(icon: Icon(Icons.settings), text: 'Settings')]),
        ),
        body: TabBarView(children: [Center(child: Text('Home Page')), Center(child: Text('Favorites Page')), Center(child: Text('Settings Page'))]),
      ),
    );
  }
}''',
        usage: 'Create tabbed navigation interface.',
        properties: [
          WidgetProperty(name: 'tabs', description: 'List of tabs'),
          WidgetProperty(name: 'controller', description: 'Tab controller'),
        ],
      ),

      WidgetModel(
        id: 'drawer',
        name: 'Drawer',
        description: 'Side navigation drawer',
        categoryId: 'navigation',
        syntax: '''Scaffold(
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Header')),
        ListTile(title: Text('Item 1'), onTap: () {}),
      ],
    ),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DrawerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drawer Example')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24))),
            ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () => Navigator.pop(context)),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: () => Navigator.pop(context)),
            ListTile(leading: Icon(Icons.info), title: Text('About'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Add side navigation drawer to app.',
        properties: [
          WidgetProperty(name: 'child', description: 'Drawer content'),
        ],
      ),

      WidgetModel(
        id: 'navigationrail',
        name: 'NavigationRail',
        description: 'Vertical navigation rail for larger screens',
        categoryId: 'navigation',
        syntax: '''NavigationRail(
  selectedIndex: selectedIndex,
  onDestinationSelected: (index) => setState(() => selectedIndex = index),
  destinations: [
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class NavigationRailExample extends StatefulWidget {
  @override
  State<NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Search')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
            ],
          ),
          Expanded(child: Center(child: Text('Page \$_selectedIndex', style: TextStyle(fontSize: 30)))),
        ],
      ),
    );
  }
}''',
        usage: 'Add vertical navigation rail for tablets/desktop.',
        properties: [
          WidgetProperty(name: 'selectedIndex', description: 'Selected item index'),
          WidgetProperty(name: 'destinations', description: 'Navigation items'),
        ],
      ),

      WidgetModel(
        id: 'navigationbar',
        name: 'NavigationBar',
        description: 'Material 3 navigation bar',
        categoryId: 'navigation',
        syntax: '''NavigationBar(
  selectedIndex: selectedIndex,
  onDestinationSelected: (index) => setState(() => selectedIndex = index),
  destinations: [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class NavigationBarExample extends StatefulWidget {
  @override
  State<NavigationBarExample> createState() => _NavigationBarExampleState();
}

class _NavigationBarExampleState extends State<NavigationBarExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page \$_selectedIndex')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}''',
        usage: 'Material 3 style bottom navigation bar.',
        properties: [
          WidgetProperty(name: 'selectedIndex', description: 'Selected item'),
          WidgetProperty(name: 'destinations', description: 'Navigation items'),
        ],
      ),

      WidgetModel(
        id: 'stepper',
        name: 'Stepper',
        description: 'Step-by-step navigation widget',
        categoryId: 'navigation',
        syntax: '''Stepper(
  currentStep: currentStep,
  onStepTapped: (step) => setState(() => currentStep = step),
  steps: [
    Step(title: Text('Step 1'), content: Text('Content 1')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class StepperExample extends StatefulWidget {
  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepTapped: (step) => setState(() => _currentStep = step),
      onStepContinue: () => setState(() => _currentStep < 2 ? _currentStep++ : null),
      onStepCancel: () => setState(() => _currentStep > 0 ? _currentStep-- : null),
      steps: [
        Step(title: Text('Account'), content: TextField(decoration: InputDecoration(labelText: 'Email'))),
        Step(title: Text('Profile'), content: TextField(decoration: InputDecoration(labelText: 'Name'))),
        Step(title: Text('Confirm'), content: Text('Confirm your details')),
      ],
    );
  }
}''',
        usage: 'Guide users through multi-step process.',
        properties: [
          WidgetProperty(name: 'currentStep', description: 'Current step index'),
          WidgetProperty(name: 'steps', description: 'List of steps'),
        ],
      ),

      WidgetModel(
        id: 'hero',
        name: 'Hero',
        description: 'Animate widget between screens',
        categoryId: 'navigation',
        syntax: '''Hero(
  tag: 'imageHero',
  child: Image.network('url'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class HeroExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen())),
      child: Hero(tag: 'hero-image', child: Container(width: 100, height: 100, color: Colors.blue)),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(tag: 'hero-image', child: Container(width: double.infinity, height: 400, color: Colors.blue)),
    );
  }
}''',
        usage: 'Create hero animations between screens.',
        properties: [
          WidgetProperty(name: 'tag', description: 'Unique identifier'),
          WidgetProperty(name: 'child', description: 'Widget to animate'),
        ],
      ),

      WidgetModel(
        id: 'breadcrumbs',
        name: 'Breadcrumb',
        description: 'Show navigation path',
        categoryId: 'navigation',
        syntax: '''Row(
  children: [
    TextButton(onPressed: () {}, child: Text('Home')),
    Text(' > '),
    TextButton(onPressed: () {}, child: Text('Category')),
    Text(' > '),
    Text('Current'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class BreadcrumbExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: () {}, child: Text('Home')),
        Icon(Icons.chevron_right, size: 16),
        TextButton(onPressed: () {}, child: Text('Products')),
        Icon(Icons.chevron_right, size: 16),
        TextButton(onPressed: () {}, child: Text('Electronics')),
        Icon(Icons.chevron_right, size: 16),
        Text('Phones', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}''',
        usage: 'Show hierarchical navigation path.',
        properties: [
          WidgetProperty(name: 'items', description: 'Breadcrumb items'),
        ],
      ),

      WidgetModel(
        id: 'backlayer',
        name: 'BackdropFilter',
        description: 'Apply filter to background',
        categoryId: 'navigation',
        syntax: '''BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  child: Container(color: Colors.black.withOpacity(0.5)),
)''',
        sourceCode: '''import 'dart:ui';
import 'package:flutter/material.dart';

class BackdropFilterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network('https://picsum.photos/400/600', fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.3), child: Center(child: Text('Blurred Background', style: TextStyle(color: Colors.white, fontSize: 30)))),
        ),
      ],
    );
  }
}''',
        usage: 'Apply visual filters to background content.',
        properties: [
          WidgetProperty(name: 'filter', description: 'Image filter to apply'),
          WidgetProperty(name: 'child', description: 'Child widget'),
        ],
      ),

      WidgetModel(
        id: 'popupmenubuttonnav',
        name: 'PopupMenuButton',
        description: 'Show popup menu for navigation',
        categoryId: 'navigation',
        syntax: '''PopupMenuButton<String>(
  onSelected: (value) {},
  itemBuilder: (context) => [
    PopupMenuItem(value: 'settings', child: Text('Settings')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PopupMenuButtonNavExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popup Menu'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => print(value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: Row(children: [Icon(Icons.person), SizedBox(width: 8), Text('Profile')])),
              PopupMenuItem(value: 'settings', child: Row(children: [Icon(Icons.settings), SizedBox(width: 8), Text('Settings')])),
              PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout), SizedBox(width: 8), Text('Logout')])),
            ],
          ),
        ],
      ),
    );
  }
}''',
        usage: 'Show popup menu for navigation options.',
        properties: [
          WidgetProperty(name: 'itemBuilder', description: 'Build menu items'),
          WidgetProperty(name: 'onSelected', description: 'Selection callback'),
        ],
      ),
    ];
  }

  static List<WidgetModel> getWidgetsByCategory(String categoryId) {
    return getAllWidgets().where((w) => w.categoryId == categoryId).toList();
  }

  static WidgetModel? getWidgetById(String id) {
    try {
      return getAllWidgets().firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
