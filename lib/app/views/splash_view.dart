import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _ringCtrl, _logoCtrl, _fadeCtrl, _barCtrl;
  late Animation<double> _rs1, _ro1, _rs2, _ro2, _logoS, _logoR, _fade, _slide, _bar;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _barCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

    _rs1  = Tween<double>(begin: 0.4, end: 1.3).animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));
    _ro1  = Tween<double>(begin: 0.7, end: 0.0).animate(CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));
    _rs2  = Tween<double>(begin: 0.3, end: 1.5).animate(CurvedAnimation(parent: _ringCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)));
    _ro2  = Tween<double>(begin: 0.4, end: 0.0).animate(CurvedAnimation(parent: _ringCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)));
    _logoS = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoR = Tween<double>(begin: -0.25, end: 0.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut));
    _fade  = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));
    _slide = Tween<double>(begin: 20.0, end: 0.0).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
    _bar   = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeInOut));

    _ringCtrl.repeat();
    Future.delayed(const Duration(milliseconds: 150), _logoCtrl.forward);
    Future.delayed(const Duration(milliseconds: 900), _fadeCtrl.forward);
    Future.delayed(const Duration(milliseconds: 700), _barCtrl.forward);
    Future.delayed(const Duration(milliseconds: 3200), () {
      final user = FirebaseAuth.instance.currentUser;
      Get.offAllNamed(user != null ? AppRoutes.home : AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _ringCtrl.dispose(); _logoCtrl.dispose(); _fadeCtrl.dispose(); _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E0C00), Color(0xFF1E1A00), Color(0xFF0E0C00)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: [
          Positioned(top: 60, right: 30,  child: _dot(5)),
          Positioned(top: 130, right: 80, child: _dot(3)),
          Positioned(top: 40, left: 50,   child: _dot(4)),
          Positioned(bottom: 120, left: 40,  child: _dot(5)),
          Positioned(bottom: 70, right: 50,  child: _dot(3)),
          Positioned(bottom: 180, right: 25, child: _dot(4)),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: 200, height: 200,
              child: Stack(alignment: Alignment.center, children: [
                AnimatedBuilder(animation: _ringCtrl, builder: (_, __) => Transform.scale(scale: _rs2.value,
                  child: Opacity(opacity: _ro2.value.clamp(0.0,1.0), child: Container(width:180,height:180,
                    decoration: BoxDecoration(shape:BoxShape.circle,border:Border.all(color:C.g500,width:1.0)))))),
                AnimatedBuilder(animation: _ringCtrl, builder: (_, __) => Transform.scale(scale: _rs1.value,
                  child: Opacity(opacity: _ro1.value.clamp(0.0,1.0), child: Container(width:160,height:160,
                    decoration: BoxDecoration(shape:BoxShape.circle,border:Border.all(color:C.g400,width:1.5)))))),
                AnimatedBuilder(animation: _logoCtrl, builder: (_, __) => Transform.scale(scale: _logoS.value,
                  child: Transform.rotate(angle: _logoR.value,
                    child: Container(width:118,height:118,
                      decoration: BoxDecoration(shape:BoxShape.circle,
                        gradient: const LinearGradient(colors:[C.g400,C.g700,Color(0xFF8A6A00)],begin:Alignment.topLeft,end:Alignment.bottomRight),
                        border:Border.all(color:C.g300,width:2),
                        boxShadow:[BoxShadow(color:C.g600.withOpacity(0.4),blurRadius:30,spreadRadius:4)]),
                      child: Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                        const Text('🪣',style:TextStyle(fontSize:44)),
                        Text('PB',style:GoogleFonts.poppins(fontSize:11,fontWeight:FontWeight.w800,color:C.s900,letterSpacing:3)),
                      ]))))),
              ])),
            const SizedBox(height: 36),
            AnimatedBuilder(animation: _fadeCtrl, builder: (_, __) => Opacity(opacity: _fade.value,
              child: Transform.translate(offset: Offset(0, _slide.value),
                child: Column(children: [
                  Text('Plastic Business', style: GoogleFonts.poppins(fontSize:30,fontWeight:FontWeight.w700,color:C.g400,letterSpacing:0.5)),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(width:32,height:1.5,decoration:BoxDecoration(color:C.g700,borderRadius:BorderRadius.circular(1))),
                    const SizedBox(width:10),
                    Text('PREMIUM',style:GoogleFonts.poppins(fontSize:11,color:C.g600,letterSpacing:4,fontWeight:FontWeight.w500)),
                    const SizedBox(width:10),
                    Container(width:32,height:1.5,decoration:BoxDecoration(color:C.g700,borderRadius:BorderRadius.circular(1))),
                  ]),
                  const SizedBox(height: 8),
                  Text('Gold & Silver Edition', style: GoogleFonts.poppins(fontSize:13,color:C.s500)),
                ])))),
            const SizedBox(height: 60),
            AnimatedBuilder(animation: _barCtrl, builder: (_, __) => Opacity(opacity: _fade.value,
              child: Column(children: [
                Padding(padding:const EdgeInsets.symmetric(horizontal:70),
                  child: ClipRRect(borderRadius:BorderRadius.circular(4),
                    child: LinearProgressIndicator(value:_bar.value,minHeight:3,
                      backgroundColor:C.s700,valueColor:const AlwaysStoppedAnimation(C.g500)))),
                const SizedBox(height:12),
                Text('Loading your business...', style:GoogleFonts.poppins(fontSize:12,color:C.s500)),
              ]))),
          ])),
          Positioned(bottom:28,left:0,right:0,
            child: AnimatedBuilder(animation:_fadeCtrl, builder:(_,__)=>Opacity(opacity:_fade.value,
              child: Text('v5.0 · Firebase Edition',textAlign:TextAlign.center,
                  style:GoogleFonts.poppins(fontSize:11,color:C.s600))))),
        ]),
      ),
    );
  }
  Widget _dot(double size) => Container(width:size,height:size,decoration:const BoxDecoration(shape:BoxShape.circle,color:C.g500));
}
