import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tvsport/api/expor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List dataJson;
  late String mesajeConex;
  late Color appColor;
  late ValueNotifier<double> progressNotifier;
  double totalcount = 400;
  late bool isLoading;
  late bool isConnecte;

  late Timer _timer;
  int _counter = 10;

  @override
  void initState() {
    isLoading = true;
    isConnecte = true;
    mesajeConex = 'Sin Conexion a Internet';
    dataJson = [];
    progressNotifier = ValueNotifier<double>(0.0);
    appColor = const Color(0xff010411);
    leeDatos();

    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if (_counter == 0) {
        timer.cancel();
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  var listener = InternetConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        break;
      case InternetConnectionStatus.disconnected:
        break;
    }
  });

  @override
  void dispose() {
    listener.cancel();

    _timer.cancel();
    super.dispose();
  }

  Future leeDatos() async {
    isConnecte = await execute(InternetConnectionChecker());

    isLoading = true;
    for (int i = 0; i <= totalcount; i++) {
      await Future.delayed(const Duration(
          milliseconds: 20)); // Simulación de retardo de 20 milisegundos
      progressNotifier.value = i / totalcount;
    }
    startTimer();

    // dataJson = await ServerApi.httpGet('gamemlb');
    dataJson = await ServerApi.httpGet('games');
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: appColor,
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: 'Recargar App',
              onPressed: () async {
                if (!isConnecte) {
                  mesajeConex = 'Reconectando Espere...';
                  await Future<void>.delayed(const Duration(seconds: 3));
                  mesajeConex = 'No hubo Conexion \n Intente De Nuevo';
                }
                dataJson.clear();
                _counter = 10;
                await leeDatos();
                setState(() {
                  startTimer();
                });
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              tooltip: 'Salir..?',
              onPressed: () {
                exit(0);
              },
              icon: const Icon(
                Icons.power_settings_new_outlined,
                color: Colors.pink,
              ),
            ),
          ],
          backgroundColor: appColor,
          title: const Center(
            child: Text(
              'TV_SPORT JD',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
        body: !isLoading && dataJson.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  dataJson.clear();
                  await leeDatos();
                  setState(() {});
                },
                child: ListView.builder(
                  itemCount: dataJson.length,
                  itemBuilder: (context, index) {
                    // String valor
                    String titulo = dataJson[index]['teams'];
                    return  ListTile(
                        title: Text(
                          dataJson[index]['inning']!,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                        subtitle: Text(titulo),
                        trailing: const Icon(Icons.chevron_right_outlined,
                            color: Colors.blueAccent),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveEvent(
                                // gameUrl:"https://s1.sportea.link/live/embed.php?ch=es20",
                                gameUrl: dataJson[index]['urlhome'],
                                tieneConexion: isConnecte,
                              ),
                            ),
                          );
                        },
                      );
                  },
                ),
              )
            : Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: progressNotifier,
                      builder: (context, value, child) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeAlign: 10,
                          strokeWidth: 10,
                          color: const Color(0xff831d3c),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<double>(
                      valueListenable: progressNotifier,
                      builder: (context, value, child) {
                        if (value < 1.0) {
                          return Text(
                              '${(value * 100).toStringAsFixed(2)}%\n Cargando..');
                        } else {
                          return Text('Espere..${_counter} ');
                        }
                      },
                    ),
                  ],
                ),
              ),
        bottomSheet: !isConnecte
            ? ScaffoldMessenger(
                child: Center(
                    child: Text(
                  '$mesajeConex',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                )),
              )
            : const SizedBox(),
      ),
    );
  }

  Future<bool> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            isConnected;
            break;
          case InternetConnectionStatus.disconnected:
            isConnected = false;
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    // if (isConnected == false) {
    //
    // }

    //await Future<void>.delayed(const Duration(seconds: 3));
    await listener.cancel();
    return isConnected;
  }
}
