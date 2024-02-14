import 'dart:html';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keycloak_flutter/keycloak_flutter.dart';
import 'package:http/http.dart' as http;
import 'config.dart' as config;

late KeycloakService keycloakService;

void main() {
  keycloakService = KeycloakService(KeycloakConfig(
      url: config.keycloak_url, 
      realm: config.keycloak_realmId,
      clientId: config.keycloak_clientId));
  keycloakService.init(
    initOptions: KeycloakInitOptions(
      onLoad: 'check-sso',
      responseMode: 'query',
      pkceMethod: config.keycloak_pkceMethod,
      flow: config.keycloak_flowType,
      silentCheckSsoRedirectUri:
          '${window.location.origin}/silent-check-sso.html',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Keycloak Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KeycloakProfile? _keycloakProfile;
  String? _accessToken;
  String? _callAPIResult;

  void _login() {
    keycloakService.login(KeycloakLoginOptions(
      redirectUri: '${window.location.origin}',
    ));
  }

  void _callAPI(String url)  {
    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
    ).then((response){
      if (response.statusCode == 200){
        _callAPIResult = response.body;
        setState(() {});
      }else{
        _callAPIResult = 'No Access';
        setState(() {});
      }
                
    }).catchError((onError) {
        print(onError);
        _callAPIResult = 'Internal Error';
        setState(() {});
      });    
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        keycloakService.keycloakEventsStream.listen((event) async {
          print(event.type);
          if (event.type == KeycloakEventType.onAuthSuccess) {
            _keycloakProfile = await keycloakService.loadUserProfile();
            _accessToken = await keycloakService.getToken(false);            
          } else {
            _keycloakProfile = null;
          }
          setState(() {});
        });
        if (keycloakService.authenticated) {
          _keycloakProfile = await keycloakService.loadUserProfile(false);
          _accessToken = await keycloakService.getToken(false);
        }
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Sample'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await keycloakService.logout();
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Ensure setup Keycloak URI, Realm and Client correctly. In this example, use standard flow Code Flow with PKCE enabled',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Welcome ${_keycloakProfile?.email ?? 'Guest, Not Logged In Yet'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
                        
            SizedBox(
              height: 20,
            ),
            if (_keycloakProfile?.username == null)
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (_keycloakProfile?.username != null)
              ElevatedButton(
                onPressed: () async {
                  print('refreshing token');
                  await keycloakService.updateToken(1000).then((value) {
                    if (value)
                       keycloakService.getToken(false).then((newToken){
                        _accessToken = newToken;
                        setState(() {});
                       });
                    print(value);
                  }).catchError((onError) {
                    print(onError);
                  });
                },
                child: Text(
                  'Refresh token',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Call API Result: ${_callAPIResult ?? 'None calling yet'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _callAPI(config.backend_API_public),
                child: Text(
                  'Public API',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _callAPI(config.backend_API_regular_user),
                child: Text(
                  'Logged-in API',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
               onPressed: () => _callAPI(config.backend_API_user_with_realm_role),
                child: Text(
                  'With Realm Role API',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SelectionArea(child: Text(
              'Access Token: ${_accessToken ?? 'None'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _login,
        tooltip: 'Login',
        child: Icon(Icons.login),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(),
    ),
  ],
);
