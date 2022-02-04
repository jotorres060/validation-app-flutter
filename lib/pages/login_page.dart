import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:validation_app/providers/login_form_provider.dart';
import 'package:validation_app/ui/input_decorations.dart';
import 'package:validation_app/widgets/widgets.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 200),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
            ],
          ),
        )
      ),
    );
  }

}

class _LoginForm extends StatelessWidget {

  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFrm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginFrm.frmKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@example.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_sharp
            ),
            onChanged: (value) => loginFrm.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null
                : 'Ingrese un correo válido.';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_clock_outlined
            ),
            onChanged: (value) => loginFrm.password = value,
            validator: (value) {
              return value != null && value.length >= 6
                ? null
                : 'La constraseña debe contener mínimo 6 caracteres.';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginFrm.isLoading ? 'Cargando...' : 'Ingresar',
                style: const TextStyle(color: Colors.white)
              ),
            ),
            onPressed: loginFrm.isLoading ? null : () async {
              FocusScope.of(context).unfocus();
              if (!loginFrm.isValidForm()) {
                return;
              }

              loginFrm.isLoading = true;
              await Future.delayed(const Duration(seconds: 3));
              loginFrm.isLoading = false;
              Navigator.pushReplacementNamed(context, 'home');
            }
          )
        ],
      )
    );
  }

}
