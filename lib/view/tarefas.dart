import 'package:flutter/material.dart';
import 'package:atividade_lista_banco/model/db_banco.dart'; 

class Tarefas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TarefasScreen(); 
  }
}

class TarefasScreen extends StatefulWidget {
  @override
  _TarefasScreenState createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Map<String, dynamic>> tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregaTarefa();
  }


  Future<void> _carregaTarefa() async {
    final tarefaList = await Bd.instance.getTarefa(); 
    setState(() {
      tarefas = tarefaList;
    });
  }

  
  Future<void> criarTafera(String nome, String descricao) async {
    await Bd.instance.criarTafera(nome, descricao); 
    _carregaTarefa(); 
  }

  
  Future<void> updateTarefa(int id, String nome, String descricao) async {
    await Bd.instance.updateTarefa(id, nome,  descricao);
    _carregaTarefa(); 
  }

  // Excluir um pedido
  Future<void> deleteTarefa(int id) async {
    await Bd.instance.deleteTarefa(id); 
    _carregaTarefa(); 
  }

  
  void _showEditDialog(BuildContext context, int id, String nome, String descricao) {
    TextEditingController nomeController = TextEditingController(text: nome);
    TextEditingController descricaoController = TextEditingController(text: descricao);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Tarefa'),
              ),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição da Tarefa '),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Atualizar"),
              onPressed: () {
                updateTarefa(id, nomeController.text, descricaoController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  void _showAddDialog(BuildContext context) {
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Adicionar Tarefa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Tarefa'),
            ),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Adicionar"),
            onPressed: () {
              criarTafera(nomeController.text, descricaoController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue[100],
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.amber[100],
              title: Text(tarefas[index]['nome'],
                style: TextStyle(color: Colors.black),  
              ),
              subtitle: Text('${tarefas[index]['descricao']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(
                      context,
                      tarefas[index]['id'],
                      tarefas[index]['nome'],
                      tarefas[index]['descricao'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTarefa(tarefas[index]['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        onPressed: () {
          setState(() {
             _showAddDialog(context);
          });
        },
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
    );
  }
}
