import 'package:fb_auth_bloc/models/custom_error.dart';
import 'package:flutter/cupertino.dart';

void errorDialog({
  required BuildContext context,
  required CustomError error,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(error.code),
        content: Text("${error.plugin}\n${error.message}"),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
