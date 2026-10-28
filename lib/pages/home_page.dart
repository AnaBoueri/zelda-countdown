import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zelda_countdown/widgets/countdown_timer.dart';
import 'package:zelda_countdown/widgets/fairy_particles.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _storyBoundaryKey = GlobalKey();
  var isSubmiting = false;

  // Pega a imagem e salva no rolo da camera
  Future<void> _exportStoryImage() async {
    setState(() => isSubmiting = true);

    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final boundary = _storyBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final xFile = XFile.fromData(
        pngBytes,
        name: 'zelda_story.png',
        mimeType: 'image/png',
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: 'Contagem regressiva Zelda OoT Remake!',
        ),
      );

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao compartilhar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isSubmiting = false);
    }
  }

  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Data alvo (4 de Novembro de 2026 às 23:59:59)
    final targetDate = DateTime(2026, 11, 04, 23, 59, 59);

    // 2. Calcula a duração total da diferença
    final Duration difference = targetDate.difference(DateTime.now());

    // 3. Se a data já tiver passado, define como zero para não exibir números negativos
    final Duration remaining = difference.isNegative ? Duration.zero : difference;

    // 4. Extrai cada componente da contagem regressiva
    final int daysRemaining = remaining.inDays;

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              Colors.black,
            ]
          )
        ),
        child: Stack(
          children:[ 

            
            Positioned(
              left: -9999,
              child: RepaintBoundary(
                key: _storyBoundaryKey,
                child: SizedBox(
                  width: 360,
                  height: 640,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),

                      const Positioned.fill(
                        child: IgnorePointer(
                          child: FairyLightsBackground(
                            numberOfParticles: 20,
                            minRadius: 3.0,
                            maxRadius: 6.0,
                            glowColor: Color(0xFFFFF2A3),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: -20,
                        child: Image.asset(
                          'assets/link.png',
                          width: 340,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.45, 1.0],
                            colors: [
                              Colors.black.withValues(alpha: 0.75),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Topo
                            Column(
                              children: [
                                Text(
                                  'THE LEGEND OF ZELDA',
                                  style: TextStyle(
                                    color: theme.colorScheme.tertiary,
                                    fontSize: 12,
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Ocarina of Time Remake',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  'FALTAM',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 22,
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '$daysRemaining', 
                                  style: TextStyle(
                                    color: theme.colorScheme.tertiary,
                                    fontSize: 120,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.8),
                                        blurRadius: 18,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'DIAS',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 22,
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 2),
                            Text(
                              '@ANABOUERI',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              )
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/link.png',
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Positioned.fill(
            child: IgnorePointer(
              child: FairyLightsBackground(
                numberOfParticles: 15,
                minRadius: 3.5,
                maxRadius: 7.0,
                glowColor: Color(0xFFFFF2A3),
              ),
            ),
          ),

            SafeArea( 
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints( maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'O DESPERTAR DO HERÓI DO TEMPO',
                        style: TextStyle(
                          fontSize:14,
                          color: theme.colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Contagem Regressiva',
                        style: GoogleFonts.cinzel(
                          fontSize: 33,
                          color: theme.colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco,
                            color: theme.colorScheme.tertiary,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Lançamento mais aguardado do ano',
                            style: TextStyle(
                              color: theme.colorScheme.tertiary.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.eco,
                            color: theme.colorScheme.tertiary,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TEMPO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'KOKIRI SPIRITS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                const SizedBox(height: 5,),

                                CountdownTimer(
                                  duration: DateTime(2026, 11, 05, 00, 00, 01).difference(DateTime.now()),
                                  onFinished: () {
                                    debugPrint('Oferta expirada!');
                                  },
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 4,
                                  children: [
                                    SvgPicture.asset(
                                    'assets/rupe.svg',
                                    width: 30,
                                    height: 30,
                                    ),
                                    SvgPicture.asset(
                                    'assets/rupe.svg',
                                    width: 30,
                                    height: 30,
                                    ),
                                    SvgPicture.asset(
                                    'assets/rupe.svg',
                                    width: 30,
                                    height: 30,
                                    ),
                                  ]
                                )
                                
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      ElevatedButton.icon(
                        onPressed: isSubmiting ? null : _exportStoryImage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: isSubmiting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.share_outlined),
                        label: Text(
                          isSubmiting ? 'Gerando imagem...' : 'Compartilhar contagem',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ), 
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      '@anaboueri',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],

                ),
              ),
            )
          )
        ]
        ),
      )
    );
  }
}