import 'package:flutter/material.dart';

import '../models/widget_category.dart';
import '../models/widget_model.dart';

/// Additional widgets from the official Flutter widget catalog.
/// See: https://docs.flutter.dev/ui/widgets
class ExtraWidgetsData {
  static List<WidgetCategory> getCategories() {
    return [
      WidgetCategory(
        id: 'animation',
        name: 'Animation',
        description: '12 motion widgets',
        icon: Icons.animation,
        color: Colors.deepOrange,
        widgetCount: 12,
      ),
      WidgetCategory(
        id: 'async',
        name: 'Async & State',
        description: '4 builder widgets',
        icon: Icons.sync,
        color: Colors.teal,
        widgetCount: 4,
      ),
      WidgetCategory(
        id: 'effects',
        name: 'Effects & Painting',
        description: '10 visual widgets',
        icon: Icons.brush,
        color: Colors.indigo,
        widgetCount: 10,
      ),
      WidgetCategory(
        id: 'interaction',
        name: 'Interaction',
        description: '6 gesture widgets',
        icon: Icons.touch_app,
        color: Colors.redAccent,
        widgetCount: 6,
      ),
      WidgetCategory(
        id: 'dialogs',
        name: 'Dialogs & Overlays',
        description: '7 overlay widgets',
        icon: Icons.layers,
        color: Colors.brown,
        widgetCount: 7,
      ),
      WidgetCategory(
        id: 'cupertino',
        name: 'Cupertino (iOS)',
        description: '8 iOS-style widgets',
        icon: Icons.phone_iphone,
        color: Colors.cyan,
        widgetCount: 8,
      ),
      WidgetCategory(
        id: 'sliver',
        name: 'Sliver Widgets',
        description: '5 scroll slivers',
        icon: Icons.view_stream,
        color: Colors.blueGrey,
        widgetCount: 5,
      ),
    ];
  }

  static List<WidgetModel> getWidgets() {
    return [
      // ============= ANIMATION (12) =============
      WidgetModel(
        id: 'animatedcontainer',
        name: 'AnimatedContainer',
        description: 'Container that animates property changes over time',
        categoryId: 'animation',
        syntax: '''AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: _expanded ? 200 : 100,
  height: _expanded ? 200 : 100,
  color: _expanded ? Colors.blue : Colors.red,
  curve: Curves.easeInOut,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  @override
  State<AnimatedContainerExample> createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: _expanded ? 200 : 100,
        height: _expanded ? 200 : 100,
        decoration: BoxDecoration(
          color: _expanded ? Colors.blue : Colors.red,
          borderRadius: BorderRadius.circular(_expanded ? 24 : 8),
        ),
        child: const Icon(Icons.touch_app, color: Colors.white),
      ),
    );
  }
}''',
        usage: 'Animate size, color, padding, and decoration changes automatically.',
        properties: [
          WidgetProperty(name: 'duration', description: 'Animation duration'),
          WidgetProperty(name: 'curve', description: 'Animation curve'),
          WidgetProperty(name: 'width', description: 'Target width'),
        ],
      ),

      WidgetModel(
        id: 'animatedopacity',
        name: 'AnimatedOpacity',
        description: 'Animates opacity changes smoothly',
        categoryId: 'animation',
        syntax: '''AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Hello'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedOpacityExample extends StatefulWidget {
  @override
  State<AnimatedOpacityExample> createState() => _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: const Text('Fade me!', style: TextStyle(fontSize: 24)),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Hide' : 'Show'),
        ),
      ],
    );
  }
}''',
        usage: 'Fade widgets in and out with smooth opacity transitions.',
        properties: [
          WidgetProperty(name: 'opacity', description: 'Target opacity 0.0–1.0'),
          WidgetProperty(name: 'duration', description: 'Animation duration'),
        ],
      ),

      WidgetModel(
        id: 'animatedcrossfade',
        name: 'AnimatedCrossFade',
        description: 'Cross-fades between two children with size animation',
        categoryId: 'animation',
        syntax: '''AnimatedCrossFade(
  firstChild: Icon(Icons.star, size: 80),
  secondChild: Icon(Icons.favorite, size: 80),
  crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  duration: Duration(milliseconds: 300),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedCrossFadeExample extends StatefulWidget {
  @override
  State<AnimatedCrossFadeExample> createState() => _AnimatedCrossFadeExampleState();
}

class _AnimatedCrossFadeExampleState extends State<AnimatedCrossFadeExample> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: const Icon(Icons.star, size: 80, color: Colors.amber),
          secondChild: const Icon(Icons.favorite, size: 80, color: Colors.red),
          crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 400),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _showFirst = !_showFirst),
          child: const Text('Toggle'),
        ),
      ],
    );
  }
}''',
        usage: 'Switch between two widgets with a cross-fade effect.',
        properties: [
          WidgetProperty(name: 'firstChild', description: 'First widget'),
          WidgetProperty(name: 'secondChild', description: 'Second widget'),
          WidgetProperty(name: 'crossFadeState', description: 'Which child to show'),
        ],
      ),

      WidgetModel(
        id: 'tweenanimationbuilder',
        name: 'TweenAnimationBuilder',
        description: 'Builds a widget animated by a Tween value',
        categoryId: 'animation',
        syntax: '''TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 1),
  duration: Duration(seconds: 1),
  builder: (context, value, child) => Opacity(opacity: value, child: child),
  child: Text('Hello'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TweenAnimationBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: const Text('Animated!', style: TextStyle(fontSize: 32)),
    );
  }
}''',
        usage: 'Simple implicit animation without an AnimationController.',
        properties: [
          WidgetProperty(name: 'tween', description: 'Value range to animate'),
          WidgetProperty(name: 'duration', description: 'Animation duration'),
          WidgetProperty(name: 'builder', description: 'Builds widget from value'),
        ],
      ),

      WidgetModel(
        id: 'animatedbuilder',
        name: 'AnimatedBuilder',
        description: 'Rebuilds when an Animation changes',
        categoryId: 'animation',
        syntax: '''AnimatedBuilder(
  animation: _controller,
  builder: (context, child) => Transform.rotate(
    angle: _controller.value * 2 * pi,
    child: child,
  ),
  child: Icon(Icons.refresh),
)''',
        sourceCode: '''import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBuilderExample extends StatefulWidget {
  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Icon(Icons.refresh, size: 64, color: Colors.blue),
    );
  }
}''',
        usage: 'Use with AnimationController for custom complex animations.',
        properties: [
          WidgetProperty(name: 'animation', description: 'Listenable to rebuild on'),
          WidgetProperty(name: 'builder', description: 'Build function'),
        ],
      ),

      WidgetModel(
        id: 'fadetransition',
        name: 'FadeTransition',
        description: 'Animates opacity using an Animation<double>',
        categoryId: 'animation',
        syntax: '''FadeTransition(
  opacity: _animation,
  child: Text('Fading text'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class FadeTransitionExample extends StatefulWidget {
  @override
  State<FadeTransitionExample> createState() => _FadeTransitionExampleState();
}

class _FadeTransitionExampleState extends State<FadeTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Text('Pulsing fade', style: TextStyle(fontSize: 24)),
    );
  }
}''',
        usage: 'Explicit fade animation driven by AnimationController.',
        properties: [
          WidgetProperty(name: 'opacity', description: 'Animation<double> for opacity'),
        ],
      ),

      WidgetModel(
        id: 'slidetransition',
        name: 'SlideTransition',
        description: 'Animates position offset of a child',
        categoryId: 'animation',
        syntax: '''SlideTransition(
  position: _animation.drive(Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)),
  child: Text('Sliding up'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SlideTransitionExample extends StatefulWidget {
  @override
  State<SlideTransitionExample> createState() => _SlideTransitionExampleState();
}

class _SlideTransitionExampleState extends State<SlideTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _offset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Slides up!'))),
    );
  }
}''',
        usage: 'Slide widgets in from off-screen positions.',
        properties: [
          WidgetProperty(name: 'position', description: 'Animation<Offset>'),
        ],
      ),

      WidgetModel(
        id: 'scaletransition',
        name: 'ScaleTransition',
        description: 'Animates scale of a child widget',
        categoryId: 'animation',
        syntax: '''ScaleTransition(
  scale: _animation,
  child: Icon(Icons.star, size: 80),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ScaleTransitionExample extends StatefulWidget {
  @override
  State<ScaleTransitionExample> createState() => _ScaleTransitionExampleState();
}

class _ScaleTransitionExampleState extends State<ScaleTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: const Icon(Icons.star, size: 80, color: Colors.amber),
    );
  }
}''',
        usage: 'Pop-in or pulse effects using scale animation.',
        properties: [
          WidgetProperty(name: 'scale', description: 'Animation<double> for scale'),
        ],
      ),

      WidgetModel(
        id: 'animatedsize',
        name: 'AnimatedSize',
        description: 'Animates its own size when child size changes',
        categoryId: 'animation',
        syntax: '''AnimatedSize(
  duration: Duration(milliseconds: 300),
  child: _expanded ? LargeWidget() : SmallWidget(),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedSizeExample extends StatefulWidget {
  @override
  State<AnimatedSizeExample> createState() => _AnimatedSizeExampleState();
}

class _AnimatedSizeExampleState extends State<AnimatedSizeExample> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _expanded
              ? Container(height: 120, width: 200, color: Colors.blue, child: const Center(child: Text('Expanded')))
              : Container(height: 60, width: 100, color: Colors.blue, child: const Center(child: Text('Small'))),
        ),
        ElevatedButton(onPressed: () => setState(() => _expanded = !_expanded), child: const Text('Toggle')),
      ],
    );
  }
}''',
        usage: 'Smoothly animate height/width when child content changes.',
        properties: [
          WidgetProperty(name: 'duration', description: 'Animation duration'),
          WidgetProperty(name: 'curve', description: 'Size animation curve'),
        ],
      ),

      WidgetModel(
        id: 'animatedalign',
        name: 'AnimatedAlign',
        description: 'Animates alignment changes of its child',
        categoryId: 'animation',
        syntax: '''AnimatedAlign(
  alignment: _topLeft ? Alignment.topLeft : Alignment.bottomRight,
  duration: Duration(milliseconds: 500),
  child: Icon(Icons.star),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class AnimatedAlignExample extends StatefulWidget {
  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  bool _topLeft = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: AnimatedAlign(
        alignment: _topLeft ? Alignment.topLeft : Alignment.bottomRight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: const Icon(Icons.star, size: 48, color: Colors.amber),
      ),
    );
  }
}''',
        usage: 'Move a child between alignment positions with animation.',
        properties: [
          WidgetProperty(name: 'alignment', description: 'Target alignment'),
          WidgetProperty(name: 'duration', description: 'Animation duration'),
        ],
      ),

      WidgetModel(
        id: 'rotationtransition',
        name: 'RotationTransition',
        description: 'Animates rotation of a child widget',
        categoryId: 'animation',
        syntax: '''RotationTransition(
  turns: _animation,
  child: Icon(Icons.settings),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RotationTransitionExample extends StatefulWidget {
  @override
  State<RotationTransitionExample> createState() => _RotationTransitionExampleState();
}

class _RotationTransitionExampleState extends State<RotationTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.settings, size: 64, color: Colors.grey),
    );
  }
}''',
        usage: 'Spinning loaders and rotating icons.',
        properties: [
          WidgetProperty(name: 'turns', description: 'Animation<double> rotations'),
        ],
      ),

      WidgetModel(
        id: 'hero_animation',
        name: 'Hero Animation',
        description: 'Shared element transition between routes',
        categoryId: 'animation',
        syntax: '''// On source screen:
Hero(tag: 'photo', child: Image.network(url))

// On destination screen:
Hero(tag: 'photo', child: Image.network(url))''',
        sourceCode: '''import 'package:flutter/material.dart';

class HeroAnimationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailPage())),
      child: Hero(
        tag: 'hero-image',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network('https://picsum.photos/200', width: 120, height: 120, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Hero(
          tag: 'hero-image',
          child: Image.network('https://picsum.photos/400', fit: BoxFit.cover),
        ),
      ),
    );
  }
}''',
        usage: 'Create seamless transitions when navigating between screens.',
        properties: [
          WidgetProperty(name: 'tag', description: 'Unique string matching both routes'),
          WidgetProperty(name: 'child', description: 'Widget to animate'),
        ],
      ),

      // ============= ASYNC & STATE (4) =============
      WidgetModel(
        id: 'futurebuilder',
        name: 'FutureBuilder',
        description: 'Builds UI based on Future snapshot state',
        categoryId: 'async',
        syntax: '''FutureBuilder<String>(
  future: fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
    if (snapshot.hasError) return Text('Error');
    return Text(snapshot.data ?? '');
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

Future<String> fetchData() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Data loaded!';
}

class FutureBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: \${snapshot.error}');
        }
        return Text(snapshot.data ?? 'No data', style: const TextStyle(fontSize: 20));
      },
    );
  }
}''',
        usage: 'Display loading, error, and success states from async operations.',
        properties: [
          WidgetProperty(name: 'future', description: 'Future to listen to'),
          WidgetProperty(name: 'builder', description: 'Builds from AsyncSnapshot'),
        ],
      ),

      WidgetModel(
        id: 'streambuilder',
        name: 'StreamBuilder',
        description: 'Builds UI based on Stream snapshot state',
        categoryId: 'async',
        syntax: '''StreamBuilder<int>(
  stream: counterStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text('\${snapshot.data}');
  },
)''',
        sourceCode: '''import 'dart:async';
import 'package:flutter/material.dart';

class StreamBuilderExample extends StatefulWidget {
  @override
  State<StreamBuilderExample> createState() => _StreamBuilderExampleState();
}

class _StreamBuilderExampleState extends State<StreamBuilderExample> {
  late StreamController<int> _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>();
    Timer.periodic(const Duration(seconds: 1), (t) {
      _controller.add(DateTime.now().second);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        return Text('Seconds: \${snapshot.data ?? 0}', style: const TextStyle(fontSize: 24));
      },
    );
  }
}''',
        usage: 'React to real-time data from streams (Firebase, WebSockets, etc.).',
        properties: [
          WidgetProperty(name: 'stream', description: 'Stream to listen to'),
          WidgetProperty(name: 'builder', description: 'Builds from AsyncSnapshot'),
        ],
      ),

      WidgetModel(
        id: 'valuelistenablebuilder',
        name: 'ValueListenableBuilder',
        description: 'Rebuilds when a ValueNotifier changes',
        categoryId: 'async',
        syntax: '''ValueListenableBuilder<int>(
  valueListenable: _counter,
  builder: (context, value, child) => Text('\$value'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ValueListenableBuilderExample extends StatefulWidget {
  @override
  State<ValueListenableBuilderExample> createState() => _ValueListenableBuilderExampleState();
}

class _ValueListenableBuilderExampleState extends State<ValueListenableBuilderExample> {
  final ValueNotifier<int> _counter = ValueNotifier(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) => Text('Count: \$value', style: const TextStyle(fontSize: 24)),
        ),
        ElevatedButton(onPressed: () => _counter.value++, child: const Text('Increment')),
      ],
    );
  }
}''',
        usage: 'Efficient rebuilds for a single value without setState on whole widget.',
        properties: [
          WidgetProperty(name: 'valueListenable', description: 'ValueNotifier to watch'),
          WidgetProperty(name: 'builder', description: 'Builds from new value'),
        ],
      ),

      WidgetModel(
        id: 'statefulbuilder',
        name: 'StatefulBuilder',
        description: 'Local setState inside a stateless parent',
        categoryId: 'async',
        syntax: '''StatefulBuilder(
  builder: (context, setState) {
    return ElevatedButton(
      onPressed: () => setState(() => count++),
      child: Text('\$count'),
    );
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class StatefulBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Text('Count: \$count', style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => setState(() => count++),
              child: const Text('Increment'),
            ),
          ],
        );
      },
    );
  }
}''',
        usage: 'Add local state in dialogs or bottom sheets without a full StatefulWidget.',
        properties: [
          WidgetProperty(name: 'builder', description: 'Receives local setState callback'),
        ],
      ),

      // ============= EFFECTS & PAINTING (10) =============
      WidgetModel(
        id: 'opacity',
        name: 'Opacity',
        description: 'Makes child partially transparent',
        categoryId: 'effects',
        syntax: '''Opacity(
  opacity: 0.5,
  child: Text('Semi-transparent'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class OpacityExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Fully visible'),
        Opacity(opacity: 0.5, child: Container(color: Colors.blue, padding: const EdgeInsets.all(16), child: const Text('50% opacity'))),
        Opacity(opacity: 0.2, child: Container(color: Colors.red, padding: const EdgeInsets.all(16), child: const Text('20% opacity'))),
      ],
    );
  }
}''',
        usage: 'Control transparency of any widget (0.0 = invisible, 1.0 = fully visible).',
        properties: [
          WidgetProperty(name: 'opacity', description: 'Value from 0.0 to 1.0'),
        ],
      ),

      WidgetModel(
        id: 'transform',
        name: 'Transform',
        description: 'Applies matrix transformation before painting',
        categoryId: 'effects',
        syntax: '''Transform.rotate(
  angle: pi / 4,
  child: Icon(Icons.star),
)

Transform.scale(
  scale: 1.5,
  child: Text('Scaled'),
)''',
        sourceCode: '''import 'dart:math';
import 'package:flutter/material.dart';

class TransformExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Transform.rotate(angle: pi / 6, child: const Icon(Icons.star, size: 48, color: Colors.amber)),
        Transform.scale(scale: 1.5, child: const Icon(Icons.favorite, size: 32, color: Colors.red)),
        Transform.translate(offset: const Offset(10, -10), child: const Icon(Icons.send, size: 48, color: Colors.blue)),
      ],
    );
  }
}''',
        usage: 'Rotate, scale, skew, or translate widgets.',
        properties: [
          WidgetProperty(name: 'transform', description: 'Matrix4 transformation'),
          WidgetProperty(name: 'alignment', description: 'Origin of transformation'),
        ],
      ),

      WidgetModel(
        id: 'rotatedbox',
        name: 'RotatedBox',
        description: 'Rotates child by quarter turns',
        categoryId: 'effects',
        syntax: '''RotatedBox(
  quarterTurns: 1,
  child: Text('Rotated 90°'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RotatedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RotatedBox(quarterTurns: 0, child: _label('0 turns')),
        RotatedBox(quarterTurns: 1, child: _label('1 turn')),
        RotatedBox(quarterTurns: 2, child: _label('2 turns')),
        RotatedBox(quarterTurns: 3, child: _label('3 turns')),
      ],
    );
  }

  Widget _label(String text) => Container(
        padding: const EdgeInsets.all(8),
        color: Colors.blue.shade100,
        child: Text(text),
      );
}''',
        usage: 'Simple 90° rotation without radians or AnimationController.',
        properties: [
          WidgetProperty(name: 'quarterTurns', description: 'Number of 90° rotations'),
        ],
      ),

      WidgetModel(
        id: 'cliprrect',
        name: 'ClipRRect',
        description: 'Clips child with rounded rectangle corners',
        categoryId: 'effects',
        syntax: '''ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.network(url),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class ClipRRectExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        'https://picsum.photos/300/200',
        width: 200,
        height: 140,
        fit: BoxFit.cover,
      ),
    );
  }
}''',
        usage: 'Rounded image corners and clipped content.',
        properties: [
          WidgetProperty(name: 'borderRadius', description: 'Corner radius'),
        ],
      ),

      WidgetModel(
        id: 'safearea',
        name: 'SafeArea',
        description: 'Insets child to avoid system UI intrusions',
        categoryId: 'effects',
        syntax: '''SafeArea(
  child: Text('Content avoids notch & status bar'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SafeAreaExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This content avoids the notch, status bar, and home indicator.', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Container(width: double.infinity, height: 100, color: Colors.blue.shade100, child: const Center(child: Text('Safe content'))),
            ],
          ),
        ),
      ),
    );
  }
}''',
        usage: 'Essential for avoiding notches, status bars, and home indicators.',
        properties: [
          WidgetProperty(name: 'top', description: 'Apply top inset'),
          WidgetProperty(name: 'bottom', description: 'Apply bottom inset'),
        ],
      ),

      WidgetModel(
        id: 'visibility',
        name: 'Visibility',
        description: 'Show or hide child while preserving layout space',
        categoryId: 'effects',
        syntax: '''Visibility(
  visible: _isVisible,
  child: Text('Hello'),
  replacement: SizedBox.shrink(),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class VisibilityExample extends StatefulWidget {
  @override
  State<VisibilityExample> createState() => _VisibilityExampleState();
}

class _VisibilityExampleState extends State<VisibilityExample> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Container(color: Colors.green, padding: const EdgeInsets.all(16), child: const Text('I can be hidden')),
        ),
        ElevatedButton(onPressed: () => setState(() => _visible = !_visible), child: Text(_visible ? 'Hide' : 'Show')),
      ],
    );
  }
}''',
        usage: 'Toggle visibility with optional layout preservation.',
        properties: [
          WidgetProperty(name: 'visible', description: 'Whether child is shown'),
          WidgetProperty(name: 'maintainSize', description: 'Keep space when hidden'),
        ],
      ),

      WidgetModel(
        id: 'richtext',
        name: 'RichText',
        description: 'Display text with multiple styles using TextSpan',
        categoryId: 'effects',
        syntax: '''RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(text: 'World', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
    ],
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class RichTextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
        children: const [
          TextSpan(text: 'Learn '),
          TextSpan(text: 'Flutter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          TextSpan(text: ' and build '),
          TextSpan(text: 'amazing', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green)),
          TextSpan(text: ' apps!'),
        ],
      ),
    );
  }
}''',
        usage: 'Mix bold, colored, and linked text in one paragraph.',
        properties: [
          WidgetProperty(name: 'text', description: 'TextSpan tree'),
        ],
      ),

      WidgetModel(
        id: 'linearprogressindicator',
        name: 'LinearProgressIndicator',
        description: 'Horizontal progress bar for loading states',
        categoryId: 'effects',
        syntax: '''LinearProgressIndicator(
  value: 0.7,
  backgroundColor: Colors.grey[200],
  color: Colors.blue,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class LinearProgressIndicatorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: 0.7, backgroundColor: Colors.grey.shade200, color: Colors.blue),
        const SizedBox(height: 8),
        const Text('70% complete'),
      ],
    );
  }
}''',
        usage: 'Show determinate or indeterminate loading progress.',
        properties: [
          WidgetProperty(name: 'value', description: 'Progress 0.0–1.0, null for indeterminate'),
          WidgetProperty(name: 'color', description: 'Progress bar color'),
        ],
      ),

      WidgetModel(
        id: 'decoratedbox',
        name: 'DecoratedBox',
        description: 'Paints a decoration behind or in front of child',
        categoryId: 'effects',
        syntax: '''DecoratedBox(
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(padding: EdgeInsets.all(16), child: Text('Gradient')),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DecoratedBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text('Gradient Box', style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}''',
        usage: 'Lower-level alternative to Container for decorations only.',
        properties: [
          WidgetProperty(name: 'decoration', description: 'BoxDecoration to paint'),
          WidgetProperty(name: 'position', description: 'Background or foreground'),
        ],
      ),

      WidgetModel(
        id: 'interactiveviewer',
        name: 'InteractiveViewer',
        description: 'Pan and zoom interactions on its child',
        categoryId: 'effects',
        syntax: '''InteractiveViewer(
  minScale: 0.5,
  maxScale: 4.0,
  child: Image.network(url),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class InteractiveViewerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Image.network(
        'https://picsum.photos/600/400',
        fit: BoxFit.contain,
      ),
    );
  }
}''',
        usage: 'Pinch-to-zoom and pan for images, maps, or large content.',
        properties: [
          WidgetProperty(name: 'minScale', description: 'Minimum zoom level'),
          WidgetProperty(name: 'maxScale', description: 'Maximum zoom level'),
        ],
      ),

      // ============= INTERACTION (6) =============
      WidgetModel(
        id: 'dismissible',
        name: 'Dismissible',
        description: 'Swipe to dismiss a list item',
        categoryId: 'interaction',
        syntax: '''Dismissible(
  key: Key(item.id),
  onDismissed: (direction) => removeItem(item),
  background: Container(color: Colors.red),
  child: ListTile(title: Text(item.name)),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DismissibleExample extends StatefulWidget {
  @override
  State<DismissibleExample> createState() => _DismissibleExampleState();
}

class _DismissibleExampleState extends State<DismissibleExample> {
  final List<String> _items = ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
          onDismissed: (_) => setState(() => _items.removeAt(index)),
          child: ListTile(title: Text(item), leading: const Icon(Icons.drag_handle)),
        );
      },
    );
  }
}''',
        usage: 'Swipe-to-delete in lists and mail apps.',
        properties: [
          WidgetProperty(name: 'onDismissed', description: 'Callback when dismissed'),
          WidgetProperty(name: 'direction', description: 'Allowed swipe directions'),
        ],
      ),

      WidgetModel(
        id: 'draggable',
        name: 'Draggable',
        description: 'Widget that can be dragged to a DragTarget',
        categoryId: 'interaction',
        syntax: '''Draggable<String>(
  data: 'item',
  feedback: Material(child: Text('Dragging')),
  child: Text('Drag me'),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DraggableExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: 'hello',
      feedback: Material(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          child: const Text('Dragging', style: TextStyle(color: Colors.white)),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _box('Drag me')),
      child: _box('Drag me'),
    );
  }

  Widget _box(String text) => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue.shade100,
        child: Text(text),
      );
}''',
        usage: 'Drag-and-drop interfaces and custom gestures.',
        properties: [
          WidgetProperty(name: 'data', description: 'Payload passed to DragTarget'),
          WidgetProperty(name: 'feedback', description: 'Widget shown while dragging'),
        ],
      ),

      WidgetModel(
        id: 'dragtarget',
        name: 'DragTarget',
        description: 'Receives data from Draggable widgets',
        categoryId: 'interaction',
        syntax: '''DragTarget<String>(
  onAcceptWithDetails: (details) => print(details.data),
  builder: (context, candidateData, rejectedData) {
    return Container(child: Text('Drop here'));
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class DragTargetExample extends StatefulWidget {
  @override
  State<DragTargetExample> createState() => _DragTargetExampleState();
}

class _DragTargetExampleState extends State<DragTargetExample> {
  String _dropped = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Draggable<String>(
          data: 'Flutter',
          feedback: const Material(child: Text('Flutter')),
          child: Container(padding: const EdgeInsets.all(16), color: Colors.blue.shade100, child: const Text('Drag this')),
        ),
        const SizedBox(height: 24),
        DragTarget<String>(
          onAcceptWithDetails: (d) => setState(() => _dropped = d.data),
          builder: (context, candidates, rejected) {
            return Container(
              height: 80,
              width: double.infinity,
              color: candidates.isNotEmpty ? Colors.green.shade100 : Colors.grey.shade200,
              alignment: Alignment.center,
              child: Text(_dropped.isEmpty ? 'Drop here' : 'Dropped: \$_dropped'),
            );
          },
        ),
      ],
    );
  }
}''',
        usage: 'Drop zones for drag-and-drop UIs.',
        properties: [
          WidgetProperty(name: 'onAcceptWithDetails', description: 'Called when item dropped'),
          WidgetProperty(name: 'builder', description: 'Builds drop zone UI'),
        ],
      ),

      WidgetModel(
        id: 'ignorepointer',
        name: 'IgnorePointer',
        description: 'Makes child invisible to touch events',
        categoryId: 'interaction',
        syntax: '''IgnorePointer(
  ignoring: _disabled,
  child: ElevatedButton(onPressed: () {}, child: Text('Disabled')),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class IgnorePointerExample extends StatefulWidget {
  @override
  State<IgnorePointerExample> createState() => _IgnorePointerExampleState();
}

class _IgnorePointerExampleState extends State<IgnorePointerExample> {
  bool _disabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: _disabled,
          child: ElevatedButton(onPressed: () {}, child: const Text('Tap me')),
        ),
        SwitchListTile(title: const Text('Disable button'), value: _disabled, onChanged: (v) => setState(() => _disabled = v)),
      ],
    );
  }
}''',
        usage: 'Disable interactions without changing widget appearance.',
        properties: [
          WidgetProperty(name: 'ignoring', description: 'Whether to ignore pointers'),
        ],
      ),

      WidgetModel(
        id: 'layoutbuilder',
        name: 'LayoutBuilder',
        description: 'Builds widget tree based on parent constraints',
        categoryId: 'interaction',
        syntax: '''LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) return WideLayout();
    return NarrowLayout();
  },
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class LayoutBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 400;
        return Container(
          color: isWide ? Colors.blue.shade100 : Colors.orange.shade100,
          padding: const EdgeInsets.all(16),
          child: Text(
            isWide ? 'Wide layout (\${constraints.maxWidth.toStringAsFixed(0)}px)' : 'Narrow layout (\${constraints.maxWidth.toStringAsFixed(0)}px)',
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}''',
        usage: 'Responsive layouts that adapt to available space.',
        properties: [
          WidgetProperty(name: 'builder', description: 'Receives BoxConstraints'),
        ],
      ),

      WidgetModel(
        id: 'indexedstack',
        name: 'IndexedStack',
        description: 'Shows one child from a list, stacking all in layout',
        categoryId: 'interaction',
        syntax: '''IndexedStack(
  index: _selectedIndex,
  children: [Page1(), Page2(), Page3()],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class IndexedStackExample extends StatefulWidget {
  @override
  State<IndexedStackExample> createState() => _IndexedStackExampleState();
}

class _IndexedStackExampleState extends State<IndexedStackExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IndexedStack(
          index: _index,
          children: [
            _page(Colors.red, 'Page 1'),
            _page(Colors.green, 'Page 2'),
            _page(Colors.blue, 'Page 3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) => IconButton(onPressed: () => setState(() => _index = i), icon: Icon(Icons.circle, color: _index == i ? Colors.black : Colors.grey))),
        ),
      ],
    );
  }

  Widget _page(Color color, String label) => Container(height: 120, color: color, child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 24))));
}''',
        usage: 'Tab-like switching while preserving each page state.',
        properties: [
          WidgetProperty(name: 'index', description: 'Index of visible child'),
          WidgetProperty(name: 'children', description: 'Stacked children'),
        ],
      ),

      // ============= DIALOGS & OVERLAYS (7) =============
      WidgetModel(
        id: 'alertdialog',
        name: 'AlertDialog',
        description: 'Material alert dialog for user decisions',
        categoryId: 'dialogs',
        syntax: '''showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Delete?'),
    content: Text('This cannot be undone.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      TextButton(onPressed: () {}, child: Text('Delete')),
    ],
  ),
);''',
        sourceCode: '''import 'package:flutter/material.dart';

class AlertDialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Delete')),
          ],
        ),
      ),
      child: const Text('Show Alert'),
    );
  }
}''',
        usage: 'Confirm actions, show warnings, or collect simple input.',
        properties: [
          WidgetProperty(name: 'title', description: 'Dialog title widget'),
          WidgetProperty(name: 'content', description: 'Dialog body'),
          WidgetProperty(name: 'actions', description: 'Action buttons'),
        ],
      ),

      WidgetModel(
        id: 'simpledialog',
        name: 'SimpleDialog',
        description: 'Simple dialog with a list of options',
        categoryId: 'dialogs',
        syntax: '''showDialog(
  context: context,
  builder: (context) => SimpleDialog(
    title: Text('Choose'),
    children: [
      SimpleDialogOption(onPressed: () {}, child: Text('Option A')),
    ],
  ),
);''',
        sourceCode: '''import 'package:flutter/material.dart';

class SimpleDialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Select Theme'),
          children: [
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 'light'), child: const Text('Light')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 'dark'), child: const Text('Dark')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 'system'), child: const Text('System')),
          ],
        ),
      ),
      child: const Text('Show Options'),
    );
  }
}''',
        usage: 'Selection dialogs with multiple choices.',
        properties: [
          WidgetProperty(name: 'title', description: 'Dialog title'),
          WidgetProperty(name: 'children', description: 'List of options'),
        ],
      ),

      WidgetModel(
        id: 'bottomsheet',
        name: 'BottomSheet',
        description: 'Modal sheet sliding up from bottom',
        categoryId: 'dialogs',
        syntax: '''showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Text('Bottom Sheet'),
  ),
);''',
        sourceCode: '''import 'package:flutter/material.dart';

class BottomSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share via', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(leading: const Icon(Icons.copy), title: const Text('Copy link'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.share), title: const Text('Share'), onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
      child: const Text('Show Bottom Sheet'),
    );
  }
}''',
        usage: 'Action menus, filters, and supplementary content.',
        properties: [
          WidgetProperty(name: 'showDragHandle', description: 'Show drag handle (M3)'),
          WidgetProperty(name: 'isScrollControlled', description: 'Allow full-height sheets'),
        ],
      ),

      WidgetModel(
        id: 'bottomappbar',
        name: 'BottomAppBar',
        description: 'Bottom app bar with optional FAB notch',
        categoryId: 'dialogs',
        syntax: '''Scaffold(
  bottomNavigationBar: BottomAppBar(
    shape: CircularNotchedRectangle(),
    child: Row(children: [IconButton(icon: Icon(Icons.menu), onPressed: () {})]),
  ),
  floatingActionButton: FloatingActionButton(onPressed: () {}),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class BottomAppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BottomAppBar')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            const SizedBox(width: 48),
            IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          ],
        ),
      ),
      body: const Center(child: Text('Content')),
    );
  }
}''',
        usage: 'Bottom navigation with centered FAB dock.',
        properties: [
          WidgetProperty(name: 'shape', description: 'Notched shape for FAB'),
          WidgetProperty(name: 'color', description: 'Bar background color'),
        ],
      ),

      WidgetModel(
        id: 'badge',
        name: 'Badge',
        description: 'Small label showing counts or status',
        categoryId: 'dialogs',
        syntax: '''Badge(
  label: Text('3'),
  child: Icon(Icons.notifications),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class BadgeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Badge(label: const Text('3'), child: IconButton(icon: const Icon(Icons.notifications), onPressed: () {})),
        Badge(label: const Text('99+'), child: IconButton(icon: const Icon(Icons.mail), onPressed: () {})),
        Badge(isLabelVisible: false, child: IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {})),
      ],
    );
  }
}''',
        usage: 'Notification counts on icons and avatars.',
        properties: [
          WidgetProperty(name: 'label', description: 'Badge text widget'),
          WidgetProperty(name: 'isLabelVisible', description: 'Show/hide label'),
        ],
      ),

      WidgetModel(
        id: 'tabbarview',
        name: 'TabBarView',
        description: 'Page view synced with TabBar selection',
        categoryId: 'dialogs',
        syntax: '''DefaultTabController(
  length: 3,
  child: Column(
    children: [
      TabBar(tabs: [Tab(text: 'A'), Tab(text: 'B')]),
      Expanded(child: TabBarView(children: [PageA(), PageB()])),
    ],
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class TabBarViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBarView'),
          bottom: const TabBar(tabs: [Tab(text: 'Home'), Tab(text: 'Search'), Tab(text: 'Profile')]),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Home Tab')),
            Center(child: Text('Search Tab')),
            Center(child: Text('Profile Tab')),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Swipeable tab content paired with TabBar.',
        properties: [
          WidgetProperty(name: 'children', description: 'One widget per tab'),
          WidgetProperty(name: 'controller', description: 'TabController instance'),
        ],
      ),

      WidgetModel(
        id: 'navigationdrawer',
        name: 'NavigationDrawer',
        description: 'Material 3 sliding navigation drawer',
        categoryId: 'dialogs',
        syntax: '''NavigationDrawer(
  selectedIndex: _index,
  onDestinationSelected: (i) => setState(() => _index = i),
  children: [
    NavigationDrawerDestination(icon: Icon(Icons.home), label: Text('Home')),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class NavigationDrawerExample extends StatefulWidget {
  @override
  State<NavigationDrawerExample> createState() => _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NavigationDrawer')),
      drawer: NavigationDrawer(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        children: const [
          NavigationDrawerDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
          NavigationDrawerDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
        ],
      ),
      body: Center(child: Text('Selected: \$_index')),
    );
  }
}''',
        usage: 'Modern M3 drawer for tablet and desktop navigation.',
        properties: [
          WidgetProperty(name: 'selectedIndex', description: 'Currently selected destination'),
          WidgetProperty(name: 'onDestinationSelected', description: 'Selection callback'),
        ],
      ),

      // ============= CUPERTINO / iOS (8) =============
      WidgetModel(
        id: 'cupertinobutton',
        name: 'CupertinoButton',
        description: 'iOS-style tappable button',
        categoryId: 'cupertino',
        syntax: '''CupertinoButton(
  onPressed: () {},
  child: Text('iOS Button'),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(onPressed: () {}, child: const Text('Default Button')),
        CupertinoButton.filled(onPressed: () {}, child: const Text('Filled Button')),
        CupertinoButton(color: CupertinoColors.destructiveRed, onPressed: () {}, child: const Text('Destructive')),
      ],
    );
  }
}''',
        usage: 'iOS-native look for cross-platform apps.',
        properties: [
          WidgetProperty(name: 'onPressed', description: 'Tap callback'),
          WidgetProperty(name: 'color', description: 'Button color'),
        ],
      ),

      WidgetModel(
        id: 'cupertinotextfield',
        name: 'CupertinoTextField',
        description: 'iOS-style text input field',
        categoryId: 'cupertino',
        syntax: '''CupertinoTextField(
  placeholder: 'Enter text',
  padding: EdgeInsets.all(12),
  prefix: Icon(CupertinoIcons.search),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTextFieldExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          placeholder: 'Search...',
          prefix: const Padding(padding: EdgeInsets.only(left: 8), child: Icon(CupertinoIcons.search)),
          padding: const EdgeInsets.all(12),
        ),
        const SizedBox(height: 12),
        CupertinoTextField(
          placeholder: 'Password',
          obscureText: true,
          padding: const EdgeInsets.all(12),
        ),
      ],
    );
  }
}''',
        usage: 'Text input matching iOS Human Interface Guidelines.',
        properties: [
          WidgetProperty(name: 'placeholder', description: 'Hint text'),
          WidgetProperty(name: 'obscureText', description: 'Hide text for passwords'),
        ],
      ),

      WidgetModel(
        id: 'cupertinoswitch',
        name: 'CupertinoSwitch',
        description: 'iOS-style toggle switch',
        categoryId: 'cupertino',
        syntax: '''CupertinoSwitch(
  value: _enabled,
  onChanged: (v) => setState(() => _enabled = v),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSwitchExample extends StatefulWidget {
  @override
  State<CupertinoSwitchExample> createState() => _CupertinoSwitchExampleState();
}

class _CupertinoSwitchExampleState extends State<CupertinoSwitchExample> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoSwitch(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
        const SizedBox(width: 12),
        Text(_enabled ? 'On' : 'Off'),
      ],
    );
  }
}''',
        usage: 'Settings toggles with native iOS appearance.',
        properties: [
          WidgetProperty(name: 'value', description: 'Current switch state'),
          WidgetProperty(name: 'onChanged', description: 'State change callback'),
        ],
      ),

      WidgetModel(
        id: 'cupertinonavigationbar',
        name: 'CupertinoNavigationBar',
        description: 'iOS-style top navigation bar',
        categoryId: 'cupertino',
        syntax: '''CupertinoNavigationBar(
  middle: Text('Title'),
  trailing: CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: () {}),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoNavigationBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: const Center(child: Text('Content')),
    );
  }
}''',
        usage: 'Top bar for Cupertino-styled screens.',
        properties: [
          WidgetProperty(name: 'middle', description: 'Title widget'),
          WidgetProperty(name: 'leading', description: 'Leading widget (back button)'),
        ],
      ),

      WidgetModel(
        id: 'cupertinopagescaffold',
        name: 'CupertinoPageScaffold',
        description: 'Basic iOS page layout with nav bar',
        categoryId: 'cupertino',
        syntax: '''CupertinoPageScaffold(
  navigationBar: CupertinoNavigationBar(middle: Text('Home')),
  child: SafeArea(child: Text('Body')),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoPageScaffoldExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Home')),
      child: SafeArea(
        child: ListView(
          children: const [
            CupertinoListTile(title: Text('Wi-Fi'), trailing: Icon(CupertinoIcons.right_chevron)),
            CupertinoListTile(title: Text('Bluetooth'), trailing: Icon(CupertinoIcons.right_chevron)),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Root layout for iOS-style pages.',
        properties: [
          WidgetProperty(name: 'navigationBar', description: 'Top navigation bar'),
          WidgetProperty(name: 'child', description: 'Page body content'),
        ],
      ),

      WidgetModel(
        id: 'cupertinotabbar',
        name: 'CupertinoTabBar',
        description: 'iOS-style bottom tab bar',
        categoryId: 'cupertino',
        syntax: '''CupertinoTabScaffold(
  tabBar: CupertinoTabBar(items: [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
  ]),
  tabBuilder: (context, index) => CupertinoTabView(builder: (context) => HomePage()),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTabBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: 'Profile'),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => Center(child: Text('Tab \$index')),
        );
      },
    );
  }
}''',
        usage: 'Bottom tabs for iOS-style multi-tab apps.',
        properties: [
          WidgetProperty(name: 'items', description: 'Tab bar items'),
          WidgetProperty(name: 'activeColor', description: 'Selected tab color'),
        ],
      ),

      WidgetModel(
        id: 'cupertinoalertdialog',
        name: 'CupertinoAlertDialog',
        description: 'iOS-style alert dialog',
        categoryId: 'cupertino',
        syntax: '''showCupertinoDialog(
  context: context,
  builder: (context) => CupertinoAlertDialog(
    title: Text('Delete?'),
    actions: [CupertinoDialogAction(child: Text('OK'), onPressed: () {})],
  ),
);''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoAlertDialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            CupertinoDialogAction(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.pop(context), child: const Text('Sign Out')),
          ],
        ),
      ),
      child: const Text('Show iOS Alert'),
    );
  }
}''',
        usage: 'Native-feeling alerts on iOS.',
        properties: [
          WidgetProperty(name: 'title', description: 'Dialog title'),
          WidgetProperty(name: 'actions', description: 'CupertinoDialogAction buttons'),
        ],
      ),

      WidgetModel(
        id: 'cupertinoslider',
        name: 'CupertinoSlider',
        description: 'iOS-style range slider',
        categoryId: 'cupertino',
        syntax: '''CupertinoSlider(
  value: _value,
  onChanged: (v) => setState(() => _value = v),
)''',
        sourceCode: '''import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSliderExample extends StatefulWidget {
  @override
  State<CupertinoSliderExample> createState() => _CupertinoSliderExampleState();
}

class _CupertinoSliderExampleState extends State<CupertinoSliderExample> {
  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoSlider(value: _value, onChanged: (v) => setState(() => _value = v)),
        Text('Value: \${_value.toStringAsFixed(2)}'),
      ],
    );
  }
}''',
        usage: 'Volume, brightness, and range controls with iOS styling.',
        properties: [
          WidgetProperty(name: 'value', description: 'Current slider value'),
          WidgetProperty(name: 'min', description: 'Minimum value'),
          WidgetProperty(name: 'max', description: 'Maximum value'),
        ],
      ),

      // ============= SLIVER (5) =============
      WidgetModel(
        id: 'sliverappbar',
        name: 'SliverAppBar',
        description: 'Collapsing app bar for CustomScrollView',
        categoryId: 'sliver',
        syntax: '''CustomScrollView(
  slivers: [
    SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(title: Text('Title')),
    ),
    SliverList(delegate: SliverChildBuilderDelegate(...)),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SliverAppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Sliver AppBar'),
            background: Image.network('https://picsum.photos/800/400', fit: BoxFit.cover),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('Item \$index')),
            childCount: 20,
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Collapsing headers in scrollable screens (like profile pages).',
        properties: [
          WidgetProperty(name: 'expandedHeight', description: 'Max height when expanded'),
          WidgetProperty(name: 'pinned', description: 'Stay visible when collapsed'),
        ],
      ),

      WidgetModel(
        id: 'sliverlist',
        name: 'SliverList',
        description: 'Lazy linear list inside a CustomScrollView',
        categoryId: 'sliver',
        syntax: '''SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => ListTile(title: Text('Item \$index')),
    childCount: 100,
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SliverListExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('SliverList'), pinned: true),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              leading: CircleAvatar(child: Text('\$index')),
              title: Text('Item \$index'),
            ),
            childCount: 50,
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Efficient scrolling lists combined with other slivers.',
        properties: [
          WidgetProperty(name: 'delegate', description: 'SliverChildDelegate'),
        ],
      ),

      WidgetModel(
        id: 'slivergrid',
        name: 'SliverGrid',
        description: 'Lazy grid inside a CustomScrollView',
        categoryId: 'sliver',
        syntax: '''SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  delegate: SliverChildBuilderDelegate(
    (context, index) => Card(child: Center(child: Text('\$index'))),
    childCount: 20,
  ),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SliverGridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('SliverGrid'), pinned: true),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Card(
              color: Colors.primaries[index % Colors.primaries.length].shade100,
              child: Center(child: Text('Item \$index')),
            ),
            childCount: 20,
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Photo grids and product catalogs in scroll views.',
        properties: [
          WidgetProperty(name: 'gridDelegate', description: 'Grid layout delegate'),
          WidgetProperty(name: 'delegate', description: 'Child builder delegate'),
        ],
      ),

      WidgetModel(
        id: 'slivertoboxadapter',
        name: 'SliverToBoxAdapter',
        description: 'Wraps a regular box widget as a sliver',
        categoryId: 'sliver',
        syntax: '''CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: BannerWidget()),
    SliverList(...),
  ],
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class SliverToBoxAdapterExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 120,
            color: Colors.blue,
            child: const Center(child: Text('Fixed Header Banner', style: TextStyle(color: Colors.white, fontSize: 20))),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(title: Text('Row \$index')),
            childCount: 30,
          ),
        ),
      ],
    );
  }
}''',
        usage: 'Insert non-sliver widgets (banners, headers) into sliver scroll views.',
        properties: [
          WidgetProperty(name: 'child', description: 'Regular box widget'),
        ],
      ),

      WidgetModel(
        id: 'nestedscrollview',
        name: 'NestedScrollView',
        description: 'Scroll view with linked inner and outer scrollables',
        categoryId: 'sliver',
        syntax: '''NestedScrollView(
  headerSliverBuilder: (context, innerBoxIsScrolled) => [
    SliverAppBar(title: Text('Nested'), pinned: true),
  ],
  body: TabBarView(children: [ListView(...), GridView(...)]),
)''',
        sourceCode: '''import 'package:flutter/material.dart';

class NestedScrollViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Nested Scroll'),
            pinned: true,
            floating: true,
            bottom: const TabBar(tabs: [Tab(text: 'List'), Tab(text: 'Grid')]),
          ),
        ],
        body: TabBarView(
          children: [
            ListView.builder(itemCount: 30, itemBuilder: (_, i) => ListTile(title: Text('Item \$i'))),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: 20,
              itemBuilder: (_, i) => Card(child: Center(child: Text('\$i'))),
            ),
          ],
        ),
      ),
    );
  }
}''',
        usage: 'Complex layouts with collapsing header + tabbed content.',
        properties: [
          WidgetProperty(name: 'headerSliverBuilder', description: 'Outer sliver header'),
          WidgetProperty(name: 'body', description: 'Inner scrollable body'),
        ],
      ),
    ];
  }
}
