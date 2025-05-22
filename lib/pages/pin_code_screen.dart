import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/providers/pin_provider.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({Key? key}) : super(key: key);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = '5555';
  bool _isChangingPin = false;
  String _newPin = '';

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _checkPin() {
    if (_pinController.text == _correctPin) {
      final pinProvider = Provider.of<PinProvider>(context, listen: false);
      pinProvider.setPinEntered();
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неверный PIN-код'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _pinController.clear();
  }

  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменение PIN-кода'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Введите новый PIN-код:'),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                hintText: 'Новый PIN-код',
              ),
              onChanged: (value) {
                _newPin = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN-код "изменен'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Сохранить'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Введите PIN-код'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Введите PIN-код',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'PIN-код',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPin,
                child: const Text('Войти'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _showChangePinDialog,
                child: const Text('Изменить PIN-код'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 