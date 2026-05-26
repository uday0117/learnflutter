import '../models/widget_model.dart';

class WidgetsData {
  static List<WidgetModel> getAllWidgets() {
    return [
      WidgetModel(
        id: 'w1',
        name: 'Container',
        description:
            'A convenience widget that combines common painting, positioning, and sizing widgets',
        explanation: '''
Container is one of the most commonly used widgets in Flutter. It can be used to:
- Add padding, margins, and borders
- Change background color or image
- Apply transformations
- Constrain child widget size

Container combines several widgets internally including Padding, Align, DecoratedBox, and ConstrainedBox.
        ''',
        parameters: [
          WidgetParameter(
            name: 'child',
            type: 'Widget?',
            description: 'The child widget to be placed inside the container',
          ),
          WidgetParameter(
            name: 'color',
            type: 'Color?',
            description: 'Background color of the container',
          ),
          WidgetParameter(
            name: 'width',
            type: 'double?',
            description: 'Width of the container',
          ),
          WidgetParameter(
            name: 'height',
            type: 'double?',
            description: 'Height of the container',
          ),
          WidgetParameter(
            name: 'padding',
            type: 'EdgeInsetsGeometry?',
            description: 'Empty space inside the container',
          ),
          WidgetParameter(
            name: 'margin',
            type: 'EdgeInsetsGeometry?',
            description: 'Empty space outside the container',
          ),
          WidgetParameter(
            name: 'decoration',
            type: 'Decoration?',
            description: 'Decoration to paint behind the child (BoxDecoration)',
          ),
          WidgetParameter(
            name: 'alignment',
            type: 'AlignmentGeometry?',
            description: 'How to align the child within the container',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class ContainerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Container Example')),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16),
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w2',
        name: 'Text',
        description: 'Display and style a run of text',
        explanation: '''
Text widget displays a string of text with a single style. It's one of the most fundamental widgets in Flutter.

The Text widget can:
- Display single-style text
- Apply text styling
- Handle text overflow
- Support text alignment
        ''',
        parameters: [
          WidgetParameter(
            name: 'data',
            type: 'String',
            description: 'The text to display',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'style',
            type: 'TextStyle?',
            description: 'Text style (font, size, color, etc.)',
          ),
          WidgetParameter(
            name: 'textAlign',
            type: 'TextAlign?',
            description: 'How to align text horizontally',
          ),
          WidgetParameter(
            name: 'maxLines',
            type: 'int?',
            description: 'Maximum number of lines',
          ),
          WidgetParameter(
            name: 'overflow',
            type: 'TextOverflow?',
            description: 'How to handle text overflow',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class TextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simple Text',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Styled Text',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This is a long text that will overflow if it exceeds the maximum number of lines',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Centered Text',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w3',
        name: 'Row',
        description: 'Layout children in a horizontal array',
        explanation: '''
Row is a widget that displays its children in a horizontal array. It's flexible and can control the alignment and size of its children.

Use Row when you want to arrange widgets horizontally.
        ''',
        parameters: [
          WidgetParameter(
            name: 'children',
            type: 'List<Widget>',
            description: 'The widgets to display horizontally',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'mainAxisAlignment',
            type: 'MainAxisAlignment',
            description: 'How to align children horizontally',
          ),
          WidgetParameter(
            name: 'crossAxisAlignment',
            type: 'CrossAxisAlignment',
            description: 'How to align children vertically',
          ),
          WidgetParameter(
            name: 'mainAxisSize',
            type: 'MainAxisSize',
            description: 'How much space to occupy horizontally',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class RowExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Row Example')),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 40),
                Icon(Icons.favorite, color: Colors.red, size: 40),
                Icon(Icons.thumb_up, color: Colors.blue, size: 40),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text('Button 1'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Button 2'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Button 3'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w4',
        name: 'Column',
        description: 'Layout children in a vertical array',
        explanation: '''
Column is a widget that displays its children in a vertical array. Similar to Row but for vertical layout.

Use Column when you want to arrange widgets vertically.
        ''',
        parameters: [
          WidgetParameter(
            name: 'children',
            type: 'List<Widget>',
            description: 'The widgets to display vertically',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'mainAxisAlignment',
            type: 'MainAxisAlignment',
            description: 'How to align children vertically',
          ),
          WidgetParameter(
            name: 'crossAxisAlignment',
            type: 'CrossAxisAlignment',
            description: 'How to align children horizontally',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class ColumnExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Column Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Learn Flutter & Dart'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get Started'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w5',
        name: 'Stack',
        description: 'Overlay widgets on top of each other',
        explanation: '''
Stack allows you to overlay multiple children widgets. Children are positioned relative to the edges of the Stack.

Perfect for:
- Badges on icons
- Overlapping elements
- Positioned backgrounds
- Custom layouts
        ''',
        parameters: [
          WidgetParameter(
            name: 'children',
            type: 'List<Widget>',
            description: 'The widgets to stack',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'alignment',
            type: 'AlignmentGeometry',
            description: 'How to align non-positioned children',
          ),
          WidgetParameter(
            name: 'fit',
            type: 'StackFit',
            description: 'How to size non-positioned children',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class StackExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stack Example')),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.blue,
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'Overlaid',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w6',
        name: 'Card',
        description: 'Material Design card with elevation',
        explanation: '''
Card is a Material Design container with slightly rounded corners and elevation.

Perfect for:
- Grouping related information
- List items
- Content panels
- Product displays
        ''',
        parameters: [
          WidgetParameter(
            name: 'child',
            type: 'Widget?',
            description: 'The widget below this widget in the tree',
          ),
          WidgetParameter(
            name: 'color',
            type: 'Color?',
            description: 'Card background color',
          ),
          WidgetParameter(
            name: 'elevation',
            type: 'double?',
            description: 'Z-coordinate for shadow',
          ),
          WidgetParameter(
            name: 'margin',
            type: 'EdgeInsetsGeometry?',
            description: 'Empty space around the card',
          ),
          WidgetParameter(
            name: 'shape',
            type: 'ShapeBorder?',
            description: 'The shape of the card',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class CardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Example')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Title',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('This is a card with some content'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.person, size: 40),
              title: Text('John Doe'),
              subtitle: Text('Flutter Developer'),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w7',
        name: 'ListView',
        description: 'Scrollable list of widgets',
        explanation: '''
ListView is a scrollable list of widgets arranged linearly. It's one of the most commonly used scrolling widgets.

Types:
- ListView() - Default constructor
- ListView.builder() - For large lists
- ListView.separated() - With separators
- ListView.custom() - Custom child model
        ''',
        parameters: [
          WidgetParameter(
            name: 'children',
            type: 'List<Widget>',
            description: 'The widgets to display in the list',
          ),
          WidgetParameter(
            name: 'scrollDirection',
            type: 'Axis',
            description: 'Direction of scroll (vertical/horizontal)',
          ),
          WidgetParameter(
            name: 'padding',
            type: 'EdgeInsetsGeometry?',
            description: 'Padding around the list',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class ListViewExample extends StatelessWidget {
  final List<String> items = List.generate(20, (i) => 'Item \${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListView Example')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('\${index + 1}'),
              ),
              title: Text(items[index]),
              subtitle: Text('Description for item \${index + 1}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                print('Tapped on \${items[index]}');
              },
            ),
          );
        },
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w8',
        name: 'GridView',
        description: 'Scrollable 2D array of widgets',
        explanation: '''
GridView creates a scrollable, 2D array of widgets. Perfect for displaying items in a grid format.

Types:
- GridView.count() - Fixed column count
- GridView.extent() - Maximum tile width
- GridView.builder() - Large grids
- GridView.custom() - Custom child model
        ''',
        parameters: [
          WidgetParameter(
            name: 'crossAxisCount',
            type: 'int',
            description: 'Number of columns',
          ),
          WidgetParameter(
            name: 'children',
            type: 'List<Widget>',
            description: 'The widgets to display',
          ),
          WidgetParameter(
            name: 'crossAxisSpacing',
            type: 'double',
            description: 'Space between columns',
          ),
          WidgetParameter(
            name: 'mainAxisSpacing',
            type: 'double',
            description: 'Space between rows',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class GridViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GridView Example')),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.all(16),
        children: List.generate(12, (index) {
          return Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.widgets,
                  size: 48,
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                Text(
                  'Item \${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w9',
        name: 'TextField',
        description: 'Text input field',
        explanation: '''
TextField is a widget that allows users to input text using a hardware or onscreen keyboard.

Features:
- Text input
- Decoration
- Validation
- Controllers
- Input formatters
        ''',
        parameters: [
          WidgetParameter(
            name: 'controller',
            type: 'TextEditingController?',
            description: 'Controls the text being edited',
          ),
          WidgetParameter(
            name: 'decoration',
            type: 'InputDecoration?',
            description: 'Decoration around the field',
          ),
          WidgetParameter(
            name: 'onChanged',
            type: 'ValueChanged<String>?',
            description: 'Called when text changes',
          ),
          WidgetParameter(
            name: 'obscureText',
            type: 'bool',
            description: 'Whether to hide the text (passwords)',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class TextFieldExample extends StatefulWidget {
  @override
  _TextFieldExampleState createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TextField Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                print('Name: \${_nameController.text}');
                print('Email: \${_emailController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      ),
      WidgetModel(
        id: 'w10',
        name: 'ElevatedButton',
        description: 'Material Design elevated button',
        explanation: '''
ElevatedButton is a Material Design button with elevation. It's one of the most commonly used buttons in Flutter.

Use ElevatedButton for:
- Primary actions
- Call-to-action buttons
- Form submissions
        ''',
        parameters: [
          WidgetParameter(
            name: 'onPressed',
            type: 'VoidCallback?',
            description: 'Called when button is pressed',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'child',
            type: 'Widget',
            description: 'Button content',
            isRequired: true,
          ),
          WidgetParameter(
            name: 'style',
            type: 'ButtonStyle?',
            description: 'Button styling',
          ),
        ],
        codeExample: '''
import 'package:flutter/material.dart';

class ElevatedButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ElevatedButton Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Button pressed!');
              },
              child: Text('Default Button'),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.send),
              label: Text('Send'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Custom Button'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: null, // Disabled button
              child: Text('Disabled Button'),
            ),
          ],
        ),
      ),
    );
  }
}
''',
      ),
    ];
  }
}
