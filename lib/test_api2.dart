// import 'package:fire_tv_listener/fire_tv_listener.dart';
// import 'package:tvsport/api/expor.dart';
// class LiveEvent extends StatefulWidget {
//   final String gameUrl;
//   final bool tieneConexion;
//
//   const LiveEvent(
//       {super.key, required this.gameUrl, required this.tieneConexion});
//
//   @override
//   State<LiveEvent> createState() => _LiveEventState();
// }
//
// class _LiveEventState extends State<LiveEvent> {
//   final globalKey = GlobalKey();
//
//   String pressed= '- PRESS A BUTTON';
//
//
//   InAppWebViewController? webViewController;
//   InAppWebViewSettings settings = InAppWebViewSettings(
//       isInspectable: kDebugMode,
//       mediaPlaybackRequiresUserGesture: false,
//       iframeAllowFullscreen: true);
//   PullToRefreshController? pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//   late Color appColor;
//   final fn = FocusNode();
//   @override
//   void initState() {
//     webViewController?.evaluateJavascript(source: "document.body.style.webkitUserSelect='auto';");
//
//     appColor = const Color(0xff010411);
//     pullToRefreshController = kIsWeb
//         ? null
//         : PullToRefreshController(
//         settings: PullToRefreshSettings(color: Colors.redAccent),
//         onRefresh: () async {
//           if (defaultTargetPlatform == TargetPlatform.android) {
//             webViewController?.reload();
//           } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//             webViewController?.loadUrl(
//                 urlRequest:
//                 URLRequest(url: await webViewController?.getUrl()));
//           }
//         });
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       FireTVRemoteListener(
//
//         onUp: () {
//           pressed = 'UP';
//           webViewController?.scrollBy(
//               x: 0, y: -100); // Por ejemplo, desplazarse hacia arriba 100 píxeles
//         },
//         onDown: () {
//           pressed = 'DOWN';
//           webViewController?.scrollBy(x: 0, y: 100);
//         },
//         onLeft: () {
//           pressed = 'LEFT';
//           webViewController?.scrollBy(x: -100, y: 0);
//         },
//         onRight: () async{
//           pressed = 'RIGHT';
//
//           await webViewController?.evaluateJavascript(
//               source: " new Promise(resolve => { document.documentElement.requestFullscreen();}) ");
//           // webViewController?.scrollBy(x: 100, y: 0);
//         },
//         onMenu: () {
//           pressed = 'MENU';
//           webViewController?.reload();
//         },
//         onSelect: () async {
//           pressed = 'SELECT';
//
//         },
//         onFF: () => pressed = 'FF',
//         onRew: () => pressed = 'REW',
//         onPlayPause: () async {
//           pressed = 'PLAY/PAUSE';
//           await webViewController?.evaluateJavascript(
//             source: "document.querySelector('video').pause();",
//           );
//         },
//         // onBack: () => back = true, // back sends android back key
//         afterButton: (event) {
//           if (event is RawKeyUpEvent) pressed = '- PRESS A BUTTON -';
//
//           if (mounted) setState(() {});
//         },
//
//         focusNode: fn,
//         child: widget.tieneConexion
//             ? Stack(
//           children: [
//             InAppWebView(
//               key: globalKey,
//
//               initialUrlRequest: URLRequest(url: WebUri(widget.gameUrl)),
//
//               initialSettings: settings,
//               pullToRefreshController: pullToRefreshController,
//               onWebViewCreated: (controller) {
//                 webViewController = controller;
//               },
//
//               onLoadStart: (controller, url) {
//                 setState(() {
//                   this.url = url.toString();
//                   urlController.text = this.url;
//                 });
//               },
//               onPermissionRequest: (controller, request) async {
//                 return PermissionResponse(
//                     resources: request.resources,
//                     action: PermissionResponseAction.GRANT);
//               },
//
//               shouldOverrideUrlLoading:
//                   (controller, navigatationActions) async {
//                 var uri = navigatationActions.request.url!;
//                 if (![
//                   "http",
//                   "https",
//                   "file",
//                   "chrome",
//                   "data",
//                   "javascript",
//                   "about"
//                 ].contains(uri.scheme)) {
//                   if (await canLaunchRul(uri)) {
//                     await launchUrl(uri);
//                     // and cancel the request
//                     return NavigationActionPolicy.CANCEL;
//                   }
//                 }
//                 return NavigationActionPolicy.ALLOW;
//               },
//
//
//               onLoadStop: (controller, url) async {
//                 pullToRefreshController?.endRefreshing();
//                 setState(() {
//                   this.url = url.toString();
//                   urlController.text = this.url;
//                 });
//               },
//               onReceivedError: (controller, request, error) {
//                 pullToRefreshController?.endRefreshing();
//               },
//               onProgressChanged: (controller, progress) {
//                 if (progress == 100) {
//                   pullToRefreshController?.endRefreshing();
//                 }
//                 setState(() {
//                   this.progress = progress / 100;
//                   urlController.text = url;
//                 });
//               },
//               onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                 setState(() {
//                   this.url = url.toString();
//                   urlController.text = this.url;
//
//                 });
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 if (kDebugMode) {
//                   // print(consoleMessage);
//                 }
//               },
//             ),
//             progress < 1.0
//                 ? LinearProgressIndicator(value: progress)
//                 : Container(),
//           ],
//         )
//             : const Center(
//           child: Text(
//             'No Internet Conexion \n Revice Su Conexion A Internet',
//             style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
//           ),
//         ),
//
//
//
//       );
//   }
//
//   ButtonStyle buildButtonStyle() {
//     return ButtonStyle(
//       iconColor: MaterialStateProperty.resolveWith(
//               (states) => const Color(0xffff004d)),
//       backgroundColor: MaterialStateProperty.resolveWith((states) => appColor),
//       elevation: MaterialStateProperty.resolveWith((states) => 0),
//     );
//   }
//
//   canLaunchRul(WebUri uri) {}
//
//   launchUrl(WebUri uri) {}
// }
