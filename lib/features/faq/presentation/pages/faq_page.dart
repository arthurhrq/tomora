import 'package:flutter/material.dart';
import 'package:tomora/core/theme/app_colors.dart';
import 'package:tomora/core/widgets/snackbar.dart';
import 'package:tomora/features/create_reminder/presentation/widgets/reminder_text_field.dart';
import 'package:tomora/features/home/presentation/widgets/home_bottom_navigation.dart';

/// Tela de Dúvidas Frequentes (FAQ).
///
/// 100% decorativa/local: não chama nenhum repositório nem a API.
/// - Os cards de "Lembretes" expandem/colapsam só com estado local
///   (respostas fixas, escritas com base no funcionamento real do app).
/// - Os campos de "Suporte" e o botão "Enviar" existem apenas
///   visualmente por enquanto; não há envio de fato (ver [_handleEnviar]).
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  // Controllers só para os campos decorativos de "Suporte" — não há
  // repository/controller de verdade por trás disso ainda.
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Respostas fixas, com base no funcionamento real do app hoje.
  static const _faq = <_FaqEntry>[
    _FaqEntry(
      question: 'O que são as cores na aba Home?',
      answer:
          'Cada lembrete aparece com uma cor de acordo com o status dele '
          'hoje: roxo é "pendente" (ainda dentro do horário), verde é '
          '"já tomou" e vermelho é "não tomou" (quando o horário passou '
          'sem resposta ou você marcou como não tomado).',
    ),
    _FaqEntry(
      question: 'O que devo fazer quando o alarme tocar?',
      answer:
          'Uma tela específica do alarme abre sozinha, com três opções: '
          '"Sim" (confirma que tomou o medicamento), "Não" (registra que '
          'não tomou) ou "Adiar" (toca de novo em 5 minutos). O som e a '
          'vibração só param quando uma dessas opções é escolhida.',
    ),
    _FaqEntry(
      question: 'Como sei qual medicamento devo tomar?',
      answer:
          'Cada card na tela inicial mostra o nome do medicamento, a '
          'dosagem e o horário do lembrete — as mesmas informações '
          'também aparecem na tela do alarme quando ele toca.',
    ),
    _FaqEntry(
      question: 'Se eu esquecer de tomar um medicamento?',
      answer:
          'Se o horário passar sem nenhuma resposta, o lembrete fica '
          'marcado como "não tomou" na Home. Você também pode marcar '
          'manualmente como tomado a qualquer momento pelo botão verde '
          'no card do lembrete.',
    ),
    _FaqEntry(
      question: 'E se eu não responder ao alarme?',
      answer:
          'O alarme continua tocando (som, vibração e volume) até você '
          'responder "Sim", "Não" ou "Adiar" — mesmo que o app seja '
          'fechado, ele volta a abrir a tela do alarme sozinho enquanto '
          'não houver resposta.',
    ),
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  /// Placeholder: por enquanto não há envio de verdade, só um retorno
  /// visual pro usuário saber que o toque foi reconhecido.
  void _handleEnviar() {
    AppSnackbar.sucess(
      'Em breve você poderá enviar mensagens para o suporte por aqui!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cordefundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 30, 32, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              const Text(
                'Lembretes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 12),

              for (final entry in _faq) ...[
                _FaqTile(entry: entry),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 14),

              const Text(
                'Suporte',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 16),

              ReminderTextField(
                label: 'Nome',
                hint: 'Digite o nome do medicamento',
                icon: Icons.link,
                controller: _nomeController,
              ),

              const SizedBox(height: 20),

              ReminderTextField(
                label: 'Descrição',
                hint: 'Insira a descrição',
                icon: Icons.description_outlined,
                controller: _descricaoController,
              ),

              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  width: 320,
                  height: 58,
                  child: _EnviarButton(onPressed: _handleEnviar),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Dúvidas Frequentes',
          style: TextStyle(
            color: AppColors.verde,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.verde,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqEntry {
  final String question;
  final String answer;

  const _FaqEntry({required this.question, required this.answer});
}

/// Pill roxo de pergunta que expande/colapsa a resposta ao tocar.
/// Estado 100% local — nenhum dado sai daqui.
class _FaqTile extends StatefulWidget {
  final _FaqEntry entry;

  const _FaqTile({required this.entry});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.deepPurple.shade200,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.entry.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _expanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.campo,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.contorno),
                  ),
                  child: Text(
                    widget.entry.answer,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

/// Botão roxo "Enviar" — mesma cor dos cards de dúvida, só pra fechar a
/// identidade visual da seção de Suporte. Não usa BotaoPrimario de
/// propósito: aquele é o verde padrão do app (login, criar lembrete...),
/// e aqui o mockup pede roxo.
class _EnviarButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _EnviarButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade200,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        'Enviar',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}