import 'package:flutter/material.dart';

void main() {
  runApp(const Contatos());
}

class Contato {
  String nome;
  String email;
  String telefone;

  Contato({
    required this.nome,
    required this.email,
    required this.telefone,
  });
}

class Contatos extends StatefulWidget {
  const Contatos({Key? key}) : super(key: key);

  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  List<Contato> contatos = [

  ];

  void atualizarContato(Contato contato, String novoNome, String novoEmail, String novoTelefone) {
    setState(() {
      contato.nome = novoNome;
      contato.email = novoEmail;
      contato.telefone = novoTelefone;
    });
  }

  void adicionarNovoContato(String nome, String email, String telefone) {
    setState(() {
      contatos.add(Contato(nome: nome, email: email, telefone: telefone));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agenda de Contatos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return ContatoItem(
              contato: contatos[index],
              onUpdate: atualizarContato,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CadastroContato(adicionarContato: adicionarNovoContato),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ContatoItem extends StatelessWidget {
  final Contato contato;
  final Function(Contato, String, String, String) onUpdate;

  const ContatoItem({
    required this.contato,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contato.nome,
        style: const TextStyle(
          color: Color(0xFF6B007D),
          fontSize: 16,
          fontFamily: 'Koulen',
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contato.email,
            style: const TextStyle(
              color: Color(0xFF6B007D),
              fontSize: 14,
              fontFamily: 'Koulen',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            contato.telefone,
            style: const TextStyle(
              color: Color(0xFF6B007D),
              fontSize: 14,
              fontFamily: 'Koulen',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarContato(contato: contato, onUpdate: onUpdate),
          ),
        );
      },
    );
  }
}

class EditarContato extends StatefulWidget {
  final Contato contato;
  final Function(Contato, String, String, String) onUpdate;

  const EditarContato({
    required this.contato,
    required this.onUpdate,
  });

  @override
  _EditarContatoState createState() => _EditarContatoState();
}

class _EditarContatoState extends State<EditarContato> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contato.nome);
    _emailController = TextEditingController(text: widget.contato.email);
    _telefoneController = TextEditingController(text: widget.contato.telefone);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(
                  widget.contato,
                  _nomeController.text,
                  _emailController.text,
                  _telefoneController.text,
                );
                Navigator.pop(context); // Fecha a tela de edição
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroContato extends StatefulWidget {
  final Function(String, String, String) adicionarContato;

  const CadastroContato({required this.adicionarContato});

  @override
  _CadastroContatoState createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.adicionarContato(
                  _nomeController.text,
                  _emailController.text,
                  _telefoneController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
