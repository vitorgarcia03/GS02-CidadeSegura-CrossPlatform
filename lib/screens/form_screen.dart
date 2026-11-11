import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ocorrencia.dart';
import '../providers/ocorrencias_provider.dart';
import '../utils/validadores.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.ocorrencia});
  final Ocorrencia? ocorrencia;
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descricao;
  late final TextEditingController _bairro;
  late final TextEditingController _endereco;
  late String _categoria;
  late String _prioridade;
  late String _status;

  bool get editando => widget.ocorrencia != null;

  @override
  void initState() {
    super.initState();
    final item = widget.ocorrencia;
    _titulo = TextEditingController(text: item?.titulo ?? '');
    _descricao = TextEditingController(text: item?.descricao ?? '');
    _bairro = TextEditingController(text: item?.bairro ?? '');
    _endereco = TextEditingController(text: item?.endereco ?? '');
    _categoria = item?.categoria ?? Ocorrencia.categorias.first;
    _prioridade = item?.prioridade ?? 'Média';
    _status = item?.status ?? 'Aberta';
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    _bairro.dispose();
    _endereco.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final agora = DateTime.now();
    final antigo = widget.ocorrencia;
    final item = Ocorrencia(
      id: antigo?.id,
      titulo: _titulo.text.trim(),
      descricao: _descricao.text.trim(),
      categoria: _categoria,
      bairro: _bairro.text.trim(),
      endereco: _endereco.text.trim(),
      prioridade: _prioridade,
      status: _status,
      criadoEm: antigo?.criadoEm ?? agora,
      atualizadoEm: agora,
    );
    final provider = context.read<OcorrenciasProvider>();
    final sucesso = editando ? await provider.editar(item) : await provider.adicionar(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(sucesso
          ? (editando ? 'Ocorrência atualizada com sucesso!' : 'Ocorrência cadastrada com sucesso!')
          : (provider.erro ?? 'Erro ao salvar.')),
    ));
    if (sucesso) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final salvando = context.watch<OcorrenciasProvider>().salvando;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar ocorrência' : 'Nova ocorrência')),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Conte o que está acontecendo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          TextFormField(
            controller: _titulo,
            decoration: const InputDecoration(labelText: 'Título *', hintText: 'Ex.: Poste sem iluminação'),
            maxLength: 80,
            textCapitalization: TextCapitalization.sentences,
            validator: Validadores.titulo,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descricao,
            decoration: const InputDecoration(labelText: 'Descrição *', hintText: 'Descreva o problema e seus impactos'),
            minLines: 3, maxLines: 5, maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            validator: Validadores.descricao,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _categoria,
            decoration: const InputDecoration(labelText: 'Categoria *'),
            isExpanded: true,
            items: Ocorrencia.categorias.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _categoria = v ?? _categoria),
            validator: (v) => Validadores.escolha(v, Ocorrencia.categorias),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bairro,
            decoration: const InputDecoration(labelText: 'Bairro *'),
            maxLength: 120,
            validator: Validadores.local,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _endereco,
            decoration: const InputDecoration(labelText: 'Endereço ou referência *'),
            maxLength: 120,
            validator: Validadores.local,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _prioridade,
            decoration: const InputDecoration(labelText: 'Prioridade *'),
            items: Ocorrencia.prioridades.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _prioridade = v ?? _prioridade),
            validator: (v) => Validadores.escolha(v, Ocorrencia.prioridades),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status *'),
            items: Ocorrencia.statusPossiveis.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _status = v ?? _status),
            validator: (v) => Validadores.escolha(v, Ocorrencia.statusPossiveis),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: salvando ? null : _salvar,
            icon: salvando
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_outlined),
            label: Text(salvando ? 'Salvando...' : (editando ? 'Salvar alterações' : 'Cadastrar ocorrência')),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
