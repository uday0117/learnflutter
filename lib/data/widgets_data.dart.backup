import 'package:flutter/material.dart';

import '../models/widget_category.dart';
import '../models/widget_model.dart';

class WidgetsData {
  static List<WidgetCategory> getCategories() {
    return [
      WidgetCategory(
        id: 'basic',
        name: 'Basic Widgets',
        description: '12 widgets',
        icon: Icons.text_fields,
        color: Colors.deepPurple,
        widgetCount: 12,
      ),
      WidgetCategory(
        id: 'layout',
        name: 'Layout Widgets',
        description: '16 widgets',
        icon: Icons.grid_view,
        color: Colors.blue,
        widgetCount: 16,
      ),
      WidgetCategory(
        id: 'input',
        name: 'Input Widgets',
        description: '14 widgets',
        icon: Icons.input,
        color: Colors.green,
        widgetCount: 14,
      ),
      WidgetCategory(
        id: 'button',
        name: 'Button Widgets',
        description: '10 widgets',
        icon: Icons.smart_button,
        color: Colors.orange,
        widgetCount: 10,
      ),
      WidgetCategory(
        id: 'list',
        name: 'List Widgets',
        description: '8 widgets',
        icon: Icons.list,
        color: Colors.pink,
        widgetCount: 8,
      ),
      WidgetCategory(
        id: 'navigation',
        name: 'Navigation Widgets',
        description: '12 widgets',
        icon: Icons.navigation,
        color: Colors.purple,
        widgetCount: 12,
      ),
    ];
  }

  static List<WidgetModel> getAllWidgets() {
    return [
      // Basic Widgets
      WidgetModel(
        id: 'text',
        name: 'Text',
        description: 'A run of text with a single style.',
        categoryId: 'basic',
        syntax: '''Text(
  'Hello World',
  style: TextStyle(fontSize: 20),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello World',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}''',
        usage: 'Use Text to display text with single style.',
        properties: [
          WidgetProperty(name: 'data', description: 'The text to display'),
          WidgetProperty(
            name: 'style',
            description: 'The style to apply to the text',
          ),
          WidgetProperty(
            name: 'textAlign',
            description: 'How to align the text',
          ),
        ],
      ),
      WidgetModel(
        id: 'icon',
        name: 'Icon',
        description: 'A graphical icon.',
        categoryId: 'basic',
        syntax: '''Icon(
  Icons.favorite,
  color: Colors.red,
  size: 30,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class IconExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite,
      color: Colors.red,
      size: 50,
    );
  }
}''',
        usage: 'Icons can be used to represent actions or items.',
        properties: [
          WidgetProperty(name: 'icon', description: 'The icon to display'),
          WidgetProperty(name: 'size', description: 'The size of the icon'),
          WidgetProperty(name: 'color', description: 'The color of the icon'),
        ],
      ),
      WidgetModel(
        id: 'image',
        name: 'Image',
        description: 'Displays an image.',
        categoryId: 'basic',
        syntax: '''Image.network(
  'https://example.com/image.png',
  width: 100,
  height: 100,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ImageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/200',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}''',
        usage: 'Use Image to display images from network, assets, or files.',
        properties: [
          WidgetProperty(name: 'image', description: 'The image to display'),
          WidgetProperty(name: 'width', description: 'The width of the image'),
          WidgetProperty(
            name: 'height',
            description: 'The height of the image',
          ),
        ],
      ),
      WidgetModel(
        id: 'container',
        name: 'Container',
        description:
            'A convenience widget that combines common painting, positioning, and sizing widgets.',
        categoryId: 'layout',
        syntax: '''Container(
  width: 100,
  height: 100,
  color: Colors.deepPurple,
  child: Text('Hi'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ContainerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Container',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}''',
        usage:
            'Use Container to decorate, position, or size a single child widget. It is one of the most commonly used widgets in Flutter.',
        properties: [
          WidgetProperty(
            name: 'width',
            description: 'The width of the container.',
          ),
          WidgetProperty(
            name: 'height',
            description: 'The height of the container.',
          ),
          WidgetProperty(name: 'color', description: 'The background color.'),
          WidgetProperty(
            name: 'margin',
            description: 'The margin outside the container.',
          ),
          WidgetProperty(
            name: 'padding',
            description: 'The padding inside the container.',
          ),
        ],
      ),
      WidgetModel(
        id: 'row',
        name: 'Row',
        description:
            'A widget that displays its children in a horizontal array.',
        categoryId: 'layout',
        syntax: '''Row(
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.star, size: 50, color: Colors.amber),
        Icon(Icons.favorite, size: 50, color: Colors.red),
        Icon(Icons.thumb_up, size: 50, color: Colors.blue),
      ],
    );
  }
}''',
        usage: 'Use Row to arrange widgets horizontally.',
        properties: [
          WidgetProperty(
            name: 'children',
            description: 'The list of child widgets',
          ),
          WidgetProperty(
            name: 'mainAxisAlignment',
            description: 'How to align children along the main axis',
          ),
        ],
      ),
      WidgetModel(
        id: 'column',
        name: 'Column',
        description: 'A widget that displays its children in a vertical array.',
        categoryId: 'layout',
        syntax: '''Column(
  children: [
    Text('First'),
    Text('Second'),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ColumnExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Line 1', style: TextStyle(fontSize: 24)),
        SizedBox(height: 10),
        Text('Line 2', style: TextStyle(fontSize: 24)),
        SizedBox(height: 10),
        Text('Line 3', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}''',
        usage: 'Use Column to arrange widgets vertically.',
        properties: [
          WidgetProperty(
            name: 'children',
            description: 'The list of child widgets',
          ),
          WidgetProperty(
            name: 'mainAxisAlignment',
            description: 'How to align children along the main axis',
          ),
        ],
      ),
      WidgetModel(
        id: 'stack',
        name: 'Stack',
        description:
            'A widget that positions its children relative to the edges of its box.',
        categoryId: 'layout',
        syntax: '''Stack(
  children: [
    Container(color: Colors.red),
    Positioned(
      top: 10,
      left: 10,
      child: Text('On top'),
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
        Container(
          width: 200,
          height: 200,
          color: Colors.blue,
        ),
        Container(
          width: 150,
          height: 150,
          color: Colors.red,
        ),
        Container(
          width: 100,
          height: 100,
          color: Colors.yellow,
        ),
      ],
    );
  }
}''',
        usage: 'Use Stack to overlay widgets on top of each other.',
        properties: [
          WidgetProperty(
            name: 'children',
            description: 'The list of child widgets',
          ),
          WidgetProperty(
            name: 'alignment',
            description: 'How to align children',
          ),
        ],
      ),
      WidgetModel(
        id: 'listview',
        name: 'ListView',
        description: 'A scrollable list of widgets.',
        categoryId: 'list',
        syntax: '''ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('\${index + 1}')),
          title: Text('Item \${index + 1}'),
          subtitle: Text('Description for item \${index + 1}'),
        );
      },
    );
  }
}''',
        usage: 'Use ListView for displaying a scrollable list of widgets.',
        properties: [
          WidgetProperty(
            name: 'children',
            description: 'The list of child widgets',
          ),
          WidgetProperty(
            name: 'scrollDirection',
            description: 'The axis along which the scroll view scrolls',
          ),
        ],
      ),
      WidgetModel(
        id: 'card',
        name: 'Card',
        description: 'A material design card.',
        categoryId: 'basic',
        syntax: '''Card(
  child: ListTile(
    title: Text('Card Title'),
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text('Card Title', style: TextStyle(fontSize: 20)),
            SizedBox(height: 5),
            Text('Card description goes here'),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Use Card for displaying content in a material design card.',
        properties: [
          WidgetProperty(
            name: 'child',
            description: 'The widget below this widget',
          ),
          WidgetProperty(
            name: 'elevation',
            description: 'The z-coordinate of the card',
          ),
        ],
      ),
      WidgetModel(
        id: 'textfield',
        name: 'TextField',
        description: 'A text input control.',
        categoryId: 'input',
        syntax: '''TextField(
  decoration: InputDecoration(
    labelText: 'Enter text',
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TextFieldExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}''',
        usage: 'Use TextField to accept text input from users.',
        properties: [
          WidgetProperty(
            name: 'decoration',
            description: 'The decoration to show around the text field',
          ),
          WidgetProperty(
            name: 'controller',
            description: 'Controls the text being edited',
          ),
        ],
      ),
      WidgetModel(
        id: 'elevated_button',
        name: 'ElevatedButton',
        description: 'A material design elevated button.',
        categoryId: 'button',
        syntax: '''ElevatedButton(
  onPressed: () {},
  child: Text('Click Me'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ElevatedButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Button pressed');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text('Click Me', style: TextStyle(fontSize: 18)),
    );
  }
}''',
        usage: 'Use ElevatedButton for primary actions in your app.',
        properties: [
          WidgetProperty(
            name: 'onPressed',
            description: 'Called when the button is tapped',
          ),
          WidgetProperty(name: 'child', description: 'The button\'s label'),
        ],
      ),
      WidgetModel(
        id: 'divider',
        name: 'Divider',
        description: 'A horizontal line.',
        categoryId: 'basic',
        syntax: '''Divider(
  color: Colors.grey,
  thickness: 2,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DividerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Above'),
        Divider(
          color: Colors.grey,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Text('Below'),
      ],
    );
  }
}''',
        usage: 'Use Divider to separate content.',
        properties: [
          WidgetProperty(
            name: 'color',
            description: 'The color of the divider',
          ),
          WidgetProperty(
            name: 'thickness',
            description: 'The thickness of the line',
          ),
        ],
      ),
      WidgetModel(
        id: 'padding',
        name: 'Padding',
        description: 'Insets empty space.',
        categoryId: 'layout',
        syntax: '''Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class PaddingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          color: Colors.blue,
          child: Center(
            child: Text('Padded', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}''',
        usage: 'Use Padding to add empty space around a widget.',
        properties: [
          WidgetProperty(
            name: 'padding',
            description: 'The amount of space to inset the child',
          ),
          WidgetProperty(
            name: 'child',
            description: 'The widget below this widget',
          ),
        ],
      ),
      WidgetModel(
        id: 'center',
        name: 'Center',
        description: 'Centers its child within itself.',
        categoryId: 'layout',
        syntax: '''Center(
  child: Text('Centered'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class CenterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.grey[300],
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          child: Center(
            child: Text('Centered', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}''',
        usage: 'Use Center to center a child widget within itself.',
        properties: [
          WidgetProperty(name: 'child', description: 'The widget to center'),
        ],
      ),
      WidgetModel(
        id: 'sizedbox',
        name: 'SizedBox',
        description: 'A box with a specified size.',
        categoryId: 'layout',
        syntax: '''SizedBox(
  width: 100,
  height: 100,
  child: Container(color: Colors.blue),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SizedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Before'),
        SizedBox(height: 30),
        Text('After 30px gap'),
        SizedBox(
          width: 200,
          height: 200,
          child: Container(color: Colors.blue),
        ),
      ],
    );
  }
}''',
        usage: 'Use SizedBox to create fixed-size boxes or spacing.',
        properties: [
          WidgetProperty(name: 'width', description: 'The width of the box'),
          WidgetProperty(name: 'height', description: 'The height of the box'),
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
