import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:party_game_app/models/game.dart';
import 'package:party_game_app/models/player.dart';
import 'package:party_game_app/providers/player_provider.dart';
import 'package:party_game_app/theme/app_theme.dart';

class WouldYouRatherScreen extends StatefulWidget {
  final Game game;

  const WouldYouRatherScreen({super.key, required this.game});

  @override
  State<WouldYouRatherScreen> createState() => _WouldYouRatherScreenState();
}

class _WouldYouRatherScreenState extends State<WouldYouRatherScreen> {
  late Player currentPlayer;
  String? currentPrompt;
  bool isLoading = false;
  bool hasSelectedOption = false;
  String? selectedOption;

  // List of would you rather prompts
  final List<Map<String, String>> prompts = [
    {
      'option1': 'No poder hablar nunca más',
      'option2': 'No poder escribir nunca más'
    },
    {
      'option1': 'Viajar al pasado para cambiar algo',
      'option2': 'Viajar al futuro para verlo todo'
    },
    {
      'option1': 'Saber cuándo vas a morir',
      'option2': 'Saber cómo vas a morir'
    },
    {
      'option1': 'Perder la capacidad de mentir',
      'option2': 'Que todos sepan cuando estás mintiendo'
    },
    {
      'option1': 'Nunca más poder reír',
      'option2': 'Nunca más poder llorar'
    },
    {
      'option1': 'Ser millonario pero no poder enamorarte',
      'option2': 'Ser pobre pero con amor verdadero'
    },
    {
      'option1': 'Tener un botón para rebobinar tu vida',
      'option2': 'Tener un botón para adelantar tu vida'
    },
    {
      'option1': 'Vivir sin música',
      'option2': 'Vivir sin películas y series'
    },
    {
      'option1': 'Poder volar',
      'option2': 'Poder hacerte invisible'
    },
    {
      'option1': 'Tener siempre frío',
      'option2': 'Tener siempre calor'
    },
    {
      'option1': 'Vivir en una mansión sin amigos',
      'option2': 'Vivir en una casa pequeña rodeado de amigos'
    },
    {
      'option1': 'Olvidar todos tus recuerdos cada año',
      'option2': 'No poder hacer nuevos recuerdos'
    },
    {
      'option1': 'Que todos puedan leer tu mente',
      'option2': 'Que todo lo que digas se haga realidad'
    },
    {
      'option1': 'Vivir 200 años con un cuerpo débil',
      'option2': 'Vivir 50 años con un cuerpo perfecto'
    },
    {
      'option1': 'Ser increíblemente atractivo pero tonto',
      'option2': 'Ser feo pero muy inteligente'
    },
    {
      'option1': 'Poder leer la mente de los demás',
      'option2': 'Que los demás lean tu mente'
    },
    {
      'option1': 'Perder todos tus dientes',
      'option2': 'Perder todos tus dedos'
    },
    {
      'option1': 'Vivir en una película de terror',
      'option2': 'Vivir en una de ciencia ficción'
    },
    {
      'option1': 'Hablar con los animales',
      'option2': 'Hablar todos los idiomas del mundo'
    },
    {
      'option1': 'Tener que susurrar siempre',
      'option2': 'Tener que gritar siempre'
    },
    // 50 new prompts
    {
      'option1': 'Comer solo comida dulce por un año',
      'option2': 'Comer solo comida salada por un año'
    },
    {
      'option1': 'No poder usar Internet nunca más',
      'option2': 'No poder ver TV nunca más'
    },
    {
      'option1': 'Saber la fecha exacta de tu muerte',
      'option2': 'No saber nada sobre cómo morirás'
    },
    {
      'option1': 'Tener la habilidad de detener el tiempo',
      'option2': 'Tener la habilidad de viajar en el tiempo'
    },
    {
      'option1': 'Perder un año de tu vida',
      'option2': 'Que tu mejor amigo pierda un año de su vida'
    },
    {
      'option1': 'No poder usar el teléfono nunca más',
      'option2': 'No poder usar la computadora nunca más'
    },
    {
      'option1': 'Vivir sin Internet por un mes',
      'option2': 'Vivir sin agua caliente por un mes'
    },
    {
      'option1': 'Ser siempre 10 minutos tarde',
      'option2': 'Ser siempre 20 minutos temprano'
    },
    {
      'option1': 'Tener que caminar en reversa por el resto de tu vida',
      'option2': 'Tener que hablar en reversa por el resto de tu vida'
    },
    {
      'option1': 'Solo poder ducharte una vez al mes',
      'option2': 'Solo poder lavarte los dientes una vez al mes'
    },
    {
      'option1': 'Tener pies por manos',
      'option2': 'Tener manos por pies'
    },
    {
      'option1': 'No poder mentir nunca más',
      'option2': 'Que todos te mientan siempre'
    },
    {
      'option1': 'Solo poder dormir 4 horas al día',
      'option2': 'Tener que dormir 16 horas al día'
    },
    {
      'option1': 'Poder cambiar el pasado',
      'option2': 'Poder prever el futuro'
    },
    {
      'option1': 'Ser la persona más graciosa del mundo',
      'option2': 'Ser la persona más inteligente del mundo'
    },
    {
      'option1': 'No poder usar emojis nunca más',
      'option2': 'Solo poder comunicarte con emojis'
    },
    {
      'option1': 'Tener superpoderes pero ser un villano',
      'option2': 'No tener poderes pero ser un héroe'
    },
    {
      'option1': 'Ver a todas las personas desnudas',
      'option2': 'Que todas las personas te vean desnudo'
    },
    {
      'option1': 'Hablar todos los idiomas pero no poder leer',
      'option2': 'Leer todos los idiomas pero no poder hablar'
    },
    {
      'option1': 'Ser experto en todo pero vivir solo 10 años más',
      'option2': 'No saber nada especial pero vivir 100 años más'
    },
    {
      'option1': 'Perder la capacidad de usar Instagram',
      'option2': 'Perder la capacidad de usar WhatsApp'
    },
    {
      'option1': 'Vivir sin amor para siempre',
      'option2': 'Vivir sin amistades para siempre'
    },
    {
      'option1': 'Tener que cantar todo lo que dices',
      'option2': 'Tener que bailar mientras hablas'
    },
    {
      'option1': 'No poder cerrar puertas nunca más',
      'option2': 'No poder abrir puertas nunca más'
    },
    {
      'option1': 'Tener siempre mal aliento',
      'option2': 'Tener siempre mal olor corporal'
    },
    {
      'option1': 'Tener la vida amorosa perfecta pero fracasar profesionalmente',
      'option2': 'Ser súper exitoso en tu carrera pero nunca encontrar el amor'
    },
    {
      'option1': 'Poder controlar tus sueños',
      'option2': 'Nunca necesitar dormir'
    },
    {
      'option1': 'Saber cómo morirá cada persona que conoces',
      'option2': 'Saber cuándo morirá cada persona que conoces'
    },
    {
      'option1': 'Poder hablar con animales muertos',
      'option2': 'Poder hablar con personas muertas'
    },
    {
      'option1': 'Tener una memoria perfecta',
      'option2': 'Tener inteligencia perfecta'
    },
    {
      'option1': 'Poder pausar el tiempo',
      'option2': 'Poder rebobinar el tiempo 10 minutos'
    },
    {
      'option1': 'No sentir nunca más dolor físico',
      'option2': 'No sentir nunca más dolor emocional'
    },
    {
      'option1': 'Tener dinero infinito pero no poder gastarlo en ti mismo',
      'option2': 'Tener dinero limitado pero poder gastarlo como quieras'
    },
    {
      'option1': 'No poder usar redes sociales para siempre',
      'option2': 'No poder ver videos/películas para siempre'
    },
    {
      'option1': 'No poder comer chocolate nunca más',
      'option2': 'No poder comer pizza nunca más'
    },
    {
      'option1': 'Estar siempre perfectamente vestido',
      'option2': 'Estar siempre perfectamente peinado'
    },
    {
      'option1': 'Perder tu sentido del gusto',
      'option2': 'Perder tu sentido del olfato'
    },
    {
      'option1': 'No poder usar buscadores como Google',
      'option2': 'No poder usar GPS o mapas'
    },
    {
      'option1': 'Poder controlar el clima',
      'option2': 'Poder controlar los sueños de otras personas'
    },
    {
      'option1': 'Tener tres piernas',
      'option2': 'Tener tres brazos'
    },
    {
      'option1': 'Solo poder comer alimentos blandos',
      'option2': 'Solo poder comer alimentos crujientes'
    },
    {
      'option1': 'No poder usar tecnología los fines de semana',
      'option2': 'No poder salir de casa los fines de semana'
    },
    {
      'option1': 'Cambiar de género cada vez que estornudas',
      'option2': 'Cambiar de edad (aleatoria) cada vez que duermes'
    },
    {
      'option1': 'Poder teletransportarte pero llegar desnudo',
      'option2': 'Poder volar pero solo a 2 metros de altura'
    },
    {
      'option1': 'Poder hablar con tu yo del pasado',
      'option2': 'Poder hablar con tu yo del futuro'
    },
    {
      'option1': 'Ver todo en blanco y negro',
      'option2': 'Escuchar todo con eco'
    },
    {
      'option1': 'Saber exactamente cómo morirás',
      'option2': 'Saber exactamente cuándo morirás'
    },
    {
      'option1': 'Tener wifi gratis de por vida',
      'option2': 'Tener comida gratis de por vida'
    },
    {
      'option1': 'Decir siempre lo que piensas',
      'option2': 'No poder expresar nunca tus opiniones'
    },
    {
      'option1': 'Tener que reír después de cada frase que digas',
      'option2': 'Tener que llorar después de cada frase que digas'
    },
    {
      'option1': 'No poder usar nunca más tu red social favorita',
      'option2': 'No poder escuchar nunca más tu canción favorita'
    },
    {
      'option1': 'Que tu vida sea un reality show',
      'option2': 'Vivir dentro de una sitcom'
    },
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

    // Get current player from provider
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    currentPlayer = playerProvider.currentPlayer!;

    // Generate a random prompt
    _generatePrompt();

    setState(() {
      isLoading = false;
      hasSelectedOption = false;
      selectedOption = null;
    });
  }

  void _generatePrompt() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % prompts.length;
    setState(() {
      currentPrompt = randomIndex.toString(); // Store the index as string
    });
  }

  void _selectOption(String option) {
    setState(() {
      hasSelectedOption = true;
      selectedOption = option;
    });
  }

  void _nextTurn() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final players = playerProvider.players;
    
    // Find current player index
    final currentIndex = players.indexWhere((p) => p.id == currentPlayer.id);
    
    // Get next player (circular)
    final nextIndex = (currentIndex + 1) % players.length;
    final nextPlayer = players[nextIndex];
    
    // Update current player
    playerProvider.setCurrentPlayer(nextPlayer.id);
    setState(() {
      currentPlayer = nextPlayer;
      hasSelectedOption = false;
      selectedOption = null;
    });
    
    // Generate new prompt
    _generatePrompt();
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
                      // Current player card
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
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: widget.game.primaryColor,
                              radius: 24,
                              child: Text(
                                currentPlayer.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Turno de',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    currentPlayer.name,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selectedOption != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.game.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "ELEGIDO",
                                  style: TextStyle(
                                    color: widget.game.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, duration: 500.ms),
                      
                      const SizedBox(height: 24),
                      
                      // Instructions
                      if (!hasSelectedOption)
                        Text(
                          "¿Qué prefieres?",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(duration: 500.ms),
                        
                      const SizedBox(height: 24),
                      
                      if (currentPrompt != null) ...[
                        // Option 1 Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: hasSelectedOption 
                                ? null 
                                : () => _selectOption('option1'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedOption == 'option1'
                                  ? widget.game.primaryColor
                                  : Colors.white,
                              foregroundColor: selectedOption == 'option1'
                                  ? Colors.white
                                  : widget.game.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: widget.game.primaryColor,
                                  width: 2,
                                ),
                              ),
                              elevation: selectedOption == 'option1' ? 8 : 2,
                            ),
                            child: Text(
                              prompts[int.parse(currentPrompt!)]['option1']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1, duration: 800.ms),
                        
                        const SizedBox(height: 20),
                        
                        // O separator
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.5),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "O",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withOpacity(0.5),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                        
                        const SizedBox(height: 20),
                        
                        // Option 2 Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: hasSelectedOption 
                                ? null 
                                : () => _selectOption('option2'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedOption == 'option2'
                                  ? widget.game.primaryColor
                                  : Colors.white,
                              foregroundColor: selectedOption == 'option2'
                                  ? Colors.white
                                  : widget.game.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: widget.game.primaryColor,
                                  width: 2,
                                ),
                              ),
                              elevation: selectedOption == 'option2' ? 8 : 2,
                            ),
                            child: Text(
                              prompts[int.parse(currentPrompt!)]['option2']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.1, duration: 800.ms),
                      ],
                      
                      const Spacer(),
                      
                      // Next turn button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: hasSelectedOption ? _nextTurn : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('SIGUIENTE TURNO'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.game.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
} 