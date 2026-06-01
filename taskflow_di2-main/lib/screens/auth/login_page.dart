import 'package:flutter/material.dart';
import 'package:taskflow_di2/screens/auth/register_page.dart';
import 'package:taskflow_di2/screens/auth/widgets/auth_text_field.dart';
import 'package:taskflow_di2/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;
  @override
  // dispose permet de nettoyer les resource , il est essentiel a la gestioon de la memoire
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final error = await _authService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    //si le widget n'est plus dansd l'arbre
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error), backgroundColor: const Color(0xFFEF4444)),
      );
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Entrez votre email d\'abord")));
      return;
    }
    final error = await _authService.sendPasswordReset(_emailController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error ?? 'Email de renitialisation envoye'),
      backgroundColor:
          error != null ? const Color(0xFFEF4444) : const Color(0xFFfE444),
    ));
  }

  Widget build(BuildContext context) {
    const indigo = Color(0xFF4F46E5);
    const indigoLight = Color(0xFFEEF2FF);
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: indigoLight,
                        borderRadius: BorderRadius.circular(16)),
                    child:
                        const Icon(Icons.bolt_rounded, size: 36, color: indigo),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  // titre
                  const Text(
                    'Bon Retour',
                    style: TextStyle(
                        fontSize: 26,
                        color: textSecondary,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text('connectez-vous a voitre espace Taskflow',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimary)),
                  const SizedBox(
                    height: 6,
                  ),
                  // const Text('Adrese email', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),),
                  AuthTextField(
                    controller: _emailController,
                    hint: 'email@gmail.com',
                    label: 'votre email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) => (v == null || !v.contains('@'))
                        ? 'email invalide'
                        : null,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // label du mot de passe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mot de passe',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimary),
                      ),
                      GestureDetector(
                        onTap: _forgotPassword,
                        child: const Text(
                          'Mot de passe opublie ?',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: indigo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  AuthTextField(
                      controller: _passwordController,
                      hint: '*******',
                      label: 'Mot de passe',
                      isPasswordd: true,
                      prefixIcon: Icons.lock_outlined,
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Minimum 6 cratceres'
                          : null),
                  // button de connexion
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Se connecter',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // separateur
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        color: borderColor,
                      )),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'ou',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 13),
                          )),
                      const Expanded(
                          child: Divider(
                        color: borderColor,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  // lien 'd'inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Pas encore de compte ?',
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterPage()),
                                ),
                                child: const Text('Creer un compte', style: TextStyle(color: indigo, fontSize: 14, fontWeight: FontWeight.w600),),
                      )
                    ],
                  )
                ],
              )),
        ),
      )),
    );
  }
}
