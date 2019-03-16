import 'package:flutter/material.dart';

class ErrorRetry extends StatelessWidget {
  final Object err;
  final VoidCallback onRetry;

  const ErrorRetry({Key key, @required this.err, @required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Row(
          children: <Widget>[
            Text('${err}', style: const TextStyle(color: Colors.red)),
            RaisedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}
