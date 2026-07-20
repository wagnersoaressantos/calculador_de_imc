import 'package:calculadora_imc/model/atividade_model.dart';
import 'package:calculadora_imc/model/sessao_usuario.dart';
import 'package:calculadora_imc/service_locator.dart';
import 'package:flutter/material.dart';

class AtividadePage extends StatefulWidget {
  const AtividadePage({super.key});

  @override
  State<AtividadePage> createState() => _AtividadePageState();
}

class _AtividadePageState extends State<AtividadePage> {
  // O cérebro da nossa app para saber quem está a usar
  final _sessao = getIt<SessaoUsuario>();

  final TextEditingController _tipoAtividadeController =
      TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();

  // 🔥 NOVO: Variável para controlar o dropdown de intensidade,
  // pois o AtividadeModel agora exige este campo obrigatório!
  String _intensidadeSelecionada = "Moderada";

  void _salvarAtividade() {
    // 1. Tratamento de Strings (.trim()) exigido no Roadmap
    final tipoAtividade = _tipoAtividadeController.text.trim();
    final duracaoTexto = _duracaoController.text.trim();

    // 2. Pega o perfil ativo automaticamente!
    final usuarioAtivo = _sessao.usuarioAtivo;

    // Prevenção de Erro: Se ninguém estiver selecionado, impede a gravação
    if (usuarioAtivo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecione um perfil primeiro na tela inicial.',
          ),
        ),
      );
      return;
    }

    // Prevenção de Erro: Campos vazios
    if (tipoAtividade.isEmpty || duracaoTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    // Prevenção de Erro: Duração inválida
    int? duracao = int.tryParse(duracaoTexto);
    if (duracao == null || duracao <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira uma duração válida em minutos.'),
        ),
      );
      return;
    }

    // 3. Montagem do Modelo com os campos corretos!
    // Aqui usamos os nomes exatos exigidos pelo AtividadeModel
    var novaAtividade = AtividadeModel(
      tipo: tipoAtividade,
      duracao: duracao,
      intensidade: _intensidadeSelecionada,
      data: DateTime.now(),
      // Opcional: Cálculo temporário simples de calorias base (5 kcal por min)
      // ou pode usar a sua lógica do serviço de análise no futuro.
      caloriasGastas: duracao * 5.0,
    );

    // 🔥 4. A GRANDE MUDANÇA ARQUITETURAL (Fase 3)
    // Em vez de gravar numa "Caixa" (Box) solta, guardamos a atividade
    // DENTRO da lista de atividades do perfil do utilizador.
    // Assim o "historico_atividade_page" e a "analise_service" vão encontrar a atividade!
    setState(() {
      usuarioAtivo.atividades.add(novaAtividade);
      usuarioAtivo.save(); // Guarda o perfil atualizado no Hive
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atividade registrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    // 5. Limpeza automática e melhoria de UX
    _tipoAtividadeController.clear();
    _duracaoController.clear();
    setState(() {
      _intensidadeSelecionada = "Moderada"; // Reseta o Dropdown
    });
    FocusScope.of(context).unfocus(); // Fecha o teclado
  }

  @override
  void dispose() {
    _tipoAtividadeController.dispose();
    _duracaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Atividade")),
      body: SingleChildScrollView(
        // Protege contra quebra de layout quando o teclado abre
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dica visual de UX: Mostra para quem estamos a gravar
            if (_sessao.usuarioAtivo != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      "A registrar para: ${_sessao.usuarioAtivo!.nome}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            TextFormField(
              controller: _tipoAtividadeController,
              decoration: const InputDecoration(
                labelText: "Qual atividade praticou? (ex: Corrida)",
                prefixIcon: Icon(Icons.directions_run),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _duracaoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Duração (em minutos)",
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            const SizedBox(height: 16),

            // 🔥 NOVO: Dropdown para selecionar a intensidade!
            DropdownButtonFormField<String>(
              value: _intensidadeSelecionada,
              decoration: const InputDecoration(
                labelText: "Intensidade do Exercício",
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items:
                  ["Leve", "Moderada", "Intensa"].map((String intensidade) {
                    return DropdownMenuItem(
                      value: intensidade,
                      child: Text(intensidade),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _intensidadeSelecionada = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _salvarAtividade,
              label: const Text("Salvar Atividade"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
