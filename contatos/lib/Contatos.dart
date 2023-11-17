import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}

class Contatos extends StatefulWidget {
  const Contatos({Key? key}) : super(key: key);

  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  late List<Contato> contatos;

  @override
  void initState() {
    super.initState();
    loadContatos();
  }

  Future<void> loadContatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String contatosJson = prefs.getString('contatos') ?? '[]';
    setState(() {
      contatos = (json.decode(contatosJson) as List)
          .map((item) => Contato.fromJson(item))
          .toList();
    });
  }

  void saveContatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String contatosJson = json.encode(contatos);
    await prefs.setString('contatos', contatosJson);
  }

  void atualizarContato(
      Contato contato, String novoNome, String novoEmail, String novoTelefone) {
    if (novoEmail.isNotEmpty && !novoEmail.contains('@')) {
      _mostrarErro("Email inválido. Certifique-se de incluir '@'.");
      return;
    }

    if (novoTelefone.isNotEmpty && !RegExp(r'^\d{2}\d{8,9}$').hasMatch(novoTelefone)) {
      _mostrarErro("Telefone inválido. Certifique-se de incluir DDD e apenas números.");
      return;
    }

    setState(() {
      contato.nome = novoNome.isNotEmpty ? novoNome : 'Untitled';
      contato.email = novoEmail;
      contato.telefone = novoTelefone;
      saveContatos();
    });
  }

  void adicionarNovoContato(String nome, String email, String telefone) {
    if (email.isNotEmpty && !email.contains('@')) {
      _mostrarErro("Email inválido. Certifique-se de incluir '@'.");
      return;
    }

    if (telefone.isNotEmpty && !RegExp(r'^\d{2}\d{8,9}$').hasMatch(telefone)) {
      _mostrarErro("Telefone inválido. Certifique-se de incluir DDD e apenas números.");
      return;
    }

    setState(() {
      contatos.add(Contato(nome: nome.isNotEmpty ? nome : 'Untitled', email: email, telefone: telefone));
      saveContatos();
    });
  }

  void apagarContato(Contato contato) {
    setState(() {
      contatos.remove(contato);
      saveContatos();
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
              onDelete: apagarContato,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CadastroContato(adicionarContato: adicionarNovoContato),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class ContatoItem extends StatelessWidget {
  final Contato contato;
  final Function(Contato, String, String, String) onUpdate;
  final Function(Contato) onDelete;

  const ContatoItem({
    required this.contato,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
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
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(Icons.person),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(context);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditarContato(contato: contato, onUpdate: onUpdate),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text("Tem certeza que deseja apagar este contato?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Não"),
            ),
            TextButton(
              onPressed: () {
                onDelete(contato);
                Navigator.of(context).pop();
              },
              child: const Text("Sim"),
            ),
          ],
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
                Navigator.pop(context);
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
