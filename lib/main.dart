import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Client client = Client();

  client
      .setEndpoint(dotenv.env['ENDPOINT']!)
      .setProject(dotenv.env['KEY_PROJECT']!)
      .setSelfSigned(status: true);

  Account account = Account(client);

  runApp(MainApp(account: account));
}

class MainApp extends StatefulWidget {
  final Account account;
  const MainApp({super.key, required this.account});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String name = '';
  User? user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Hello World!'),
              TextButton(
                onPressed: () async {
                  try {
                    final res = await widget.account
                        .createOAuth2Session(provider: 'google');

                    Logger().i('Google signin', error: res);

                    user = await widget.account.get();

                    if (user != null) {
                      Logger().i('User', error: user!.name);

                      setState(() {
                        name = user!.name;
                      });
                    }
                  } on AppwriteException catch (e) {
                    Logger().i('AppwriteException::', error: e.message);
                  }
                },
                child: const Text('Google'),
              ),
              Text(name),
              TextButton(
                onPressed: () async {
                  try {
                    setState(() {
                      name = '';
                    });
                  } on AppwriteException catch (e) {
                    Logger().i('AppwriteException::', error: e.message);
                  }
                },
                child: const Text('Salir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
