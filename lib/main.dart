import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'button.dart';
import 'layer1.dart';
import 'providers/calculation.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CalculationProvider>(
      create: (context) => CalculationProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme:
                lightColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            textTheme: const TextTheme(
              labelLarge:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              bodyMedium:
                  TextStyle(fontSize: 32.0, fontWeight: FontWeight.w300),
            )),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: darkColorScheme ??
              ColorScheme.fromSeed(
                  brightness: Brightness.dark, seedColor: Colors.red.shade300),
          useMaterial3: true,
          textTheme: const TextTheme(
              labelLarge:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300),
              bodyMedium:
                  TextStyle(fontSize: 32.0, fontWeight: FontWeight.w300)),
        ),
        home: const CalculatorGrid(),
        themeMode: ThemeMode.system,
      );
    });
  }
}

class CalculatorGrid extends StatefulWidget {
  const CalculatorGrid({super.key});

  @override
  State<CalculatorGrid> createState() => _CalculatorGridState();
}

class _CalculatorGridState extends State<CalculatorGrid> {
  @override
  Widget build(BuildContext context) {
    Size dim = MediaQuery.of(context).size;
    List<Widget> list2 = const [
      Button("AC"),
      Button(
        "<-",
        iconButton: Icon(Icons.backspace),
      ),
      Button("%"),
      Button("/", circular: true),
      Button("7"),
      Button("8"),
      Button("9"),
      Button("x", circular: true),
      Button("4"),
      Button("5"),
      Button("6"),
      Button("-", circular: true),
      Button("1"),
      Button("2"),
      Button("3"),
      Button("+", circular: true),
      Button(""),
      Button("0"),
      Button("."),
      Button("=", circular: true)
    ];

    return SafeArea(
      child: Scaffold(
        body: Consumer<CalculationProvider>(builder: (context, calc, child) {
          return SlidingUpPanel(
            body: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: dim.height / 1.9,
                  child: GridView.builder(
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 70,
                    ),
                    itemBuilder: (context, index) {
                      return list2[index];
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                )),
            minHeight: dim.height / 2.25,
            maxHeight: dim.height - 52.0,
            slideDirection: SlideDirection.DOWN,
            header: Padding(
              padding:
                  EdgeInsets.only(left: (dim.width / 2) - 16.0, bottom: 8.0),
              child: Card(
                color: Colors.grey.shade300,
                child: const SizedBox(
                  height: 4.0,
                  width: 32.0,
                ),
              ),
            ),
            collapsed: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 120,
                  flexibleSpace: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Calculator',
                      style: TextStyle(fontSize: 44.0),
                    ),
                  )),
              body: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SingleChildScrollView(
                            reverse: true,
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              calc.getExpression ?? "",
                              // style: TextStyle(fontSize: 24.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Card(
                        color: Colors.grey.shade300,
                        child: const SizedBox(height: 4.0, width: 32.0),
                      )
                    ]),
                  )),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(blurRadius: 2.0, color: Color.fromRGBO(0, 0, 0, 0.25))
            ],
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
            panel: const Layer1(),
          );
        }),
      ),
    );
  }
}
