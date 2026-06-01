import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskflow_di2/services/auth/auth_service.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user =FirebaseAuth.instance.currentUser;
    final authService=AuthService();
      const indigo = Color(0xFF4F46E5);
    const indigoLight = Color(0xFFEEF2FF);
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Taskflow', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700),),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () async => await authService.logout() ,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: indigoLight,
                borderRadius: BorderRadius.circular(8)
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 16, color: textSecondary),
                  SizedBox(width: 6,),
                  Text('Deconnexion', style: TextStyle(color: textSecondary, fontSize: 13),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}