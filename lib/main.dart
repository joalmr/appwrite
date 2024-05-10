import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();

  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('6604b3becd694d057bf5')
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

                    User? user = await widget.account.get();

                    Logger().i('User', error: user.name);

                    setState(() {
                      name = user.name;
                    });
                  } on AppwriteException catch (e) {
                    Logger().i('AppwriteException::', error: e.message);
                  }
                },
                child: const Text('Google'),
              ),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
