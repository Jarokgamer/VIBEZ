import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/theme/app_theme.dart';

class NeverHaveIEverScreen extends StatefulWidget {
  final Game game;

  const NeverHaveIEverScreen({super.key, required this.game});

  @override
  State<NeverHaveIEverScreen> createState() => _NeverHaveIEverScreenState();
}

class _NeverHaveIEverScreenState extends State<NeverHaveIEverScreen> {
  String? currentPrompt;
  bool isLoading = false;

  final List<String> prompts = [
    'He fingido estar enfermo para evitar ir al trabajo o a clases',
    'He enviado un mensaje de texto al destinatario equivocado',
    'He comido algo que se cayó al suelo',
    'He cantado en la ducha',
    'He hablado con mi mascota como si fuera una persona',
    'He buscado mi propio nombre en Google',
    'He usado ropa de mi pareja sin que él o ella lo supiera',
    'He llorado viendo una película',
    'He reprobado un examen',
    'He olvidado el cumpleaños de un amigo cercano',
    'He mentido sobre mi edad',
    'He hecho trampa en un juego de mesa',
    'He fingido conocer a alguien que no recordaba',
    'He comprado algo y luego me he arrepentido',
    'He perdido las llaves de mi casa',
    'He olvidado una cita importante',
    'He dicho "Te amo" sin sentirlo',
    'He tenido una cita a ciegas',
    'He hecho una broma pesada a alguien',
    'He sido arrestado',
    'He viajado solo',
    'He comido comida de mascota',
    'He fingido saber algo que no sabía',
    'He tenido un apodo vergonzoso',
    'He mentido en mi currículum',
    'He robado algo',
    'He besado a alguien del mismo sexo',
    'He enviado un mensaje borracho',
    'He espiado el teléfono de alguien',
    'He fingido una lesión',
    'He mentido sobre mi estado sentimental',
    'He fingido orgasmos',
    'He tenido un crush con el profesor',
    'He mentido sobre mi salario',
    'He stalkeado a mi ex en redes sociales',
    'He fingido estar ocupado para evitar planes',
    'He leído el diario de alguien',
    'He mentido sobre mi peso',
    'He fingido estar dormido',
    'He hecho ghosting a alguien',
    'He mentido sobre mi experiencia laboral',
    'He fingido estar en una relación',
    'He mentido sobre mi orientación sexual',
    'He fingido un orgasmo',
    'He mentido sobre mi edad en una app de citas',
    'He fingido estar enfermo para faltar a una cita',
    'He mentido sobre mi estado civil',
    'He fingido estar borracho',
    'He mentido sobre mi nacionalidad',
    'He fingido estar dormido para evitar una conversación',
    'He mentido sobre mi nivel de educación',
    'He fingido estar ocupado en el teléfono',
    'He mentido sobre mi situación financiera',
    'He fingido estar enfermo para no ir a una fiesta',
    'He mentido sobre mi estado de salud',
    'He fingido estar interesado en alguien',
    'He mentido sobre mi experiencia sexual',
    'He fingido estar feliz cuando estaba triste',
    'He mentido sobre mi pasado',
    'He fingido estar sobrio',
    'He mentido sobre mis intenciones',
    'He fingido estar enamorado',
    'He mentido sobre mi identidad',
    'He fingido estar soltero',
    'He mentido sobre mi trabajo',
    'He fingido estar casado',
    'He mentido sobre mis sentimientos',
    'He fingido estar embarazada',
    'He mentido sobre mi familia',
    'He fingido estar comprometido',
    'He mentido sobre mis logros',
    'He fingido estar rico',
    'He mentido sobre mis habilidades',
    'He fingido estar pobre',
    'He mentido sobre mis intenciones románticas',
    'He fingido estar enfermo para conseguir atención',
    'He mentido sobre mis planes futuros',
    'He fingido estar ocupado para evitar ayudar',
    'He mentido sobre mis creencias',
    'He fingido estar interesado en un hobby',
    'He mentido sobre mis metas',
    'He fingido estar en una relación seria',
    'He mentido sobre mis preferencias',
    'He fingido estar estudiando',
    'He mentido sobre mis talentos',
    'He fingido estar trabajando',
    'He mentido sobre mis relaciones pasadas',
    'He fingido estar durmiendo para evitar responsabilidades',
    'He mentido sobre mis aspiraciones',
    'He fingido estar ocupado para evitar una reunión',
    'He mentido sobre mis errores',
    'He fingido estar enfermo para conseguir simpatía',
    'He mentido sobre mis intenciones laborales',
    'He fingido estar interesado en una conversación',
    'He mentido sobre mis razones',
    'He fingido estar ocupado para evitar un compromiso',
    'He mentido sobre mis motivaciones',
    'He fingido estar enfermo para conseguir un favor',
    'He mentido sobre mis verdaderos deseos',
    'He fingido estar ocupado para evitar una responsabilidad',
    'He mentido sobre mis verdaderos pensamientos',
    'He fingido estar enfermo para conseguir atención médica',
    'He mentido sobre mis verdaderos sentimientos',
    'He fingido estar ocupado para evitar un evento social',
    'He mentido sobre mis verdaderas intenciones'
  ];

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    setState(() {
      isLoading = true;
    });

    _generatePrompt();

    setState(() {
      isLoading = false;
    });
  }

  void _generatePrompt() {
    setState(() {
      currentPrompt = prompts[DateTime.now().millisecond % prompts.length];
    });
  }

  void _nextTurn() {
    setState(() {
      _generatePrompt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: widget.game.primaryColor.withOpacity(0.8),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.game.primaryColor.withOpacity(0.7),
                    AppTheme.backgroundColor,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.game.name,
                            style: TextStyle(
                              color: widget.game.primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 500.ms),

                      const Spacer(),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: widget.game.primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: widget.game.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_bar,
                              color: Colors.white.withOpacity(0.9),
                              size: 48,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              currentPrompt ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9), duration: 800.ms),

                      const Spacer(),

                      ElevatedButton.icon(
                        onPressed: _nextTurn,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('SIGUIENTE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surfaceColor,
                          foregroundColor: AppTheme.textPrimaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2, duration: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}