import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'note.dart';
import 'note_db.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;
  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();

  DateTime? _deadline;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    if (n != null) {
      _titleC.text = n.title;
      _contentC.text = n.content;
      _deadline = n.deadline;
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _contentC.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final init = _deadline ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(init.year, init.month, init.day),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  void _clearDeadline() {
    setState(() => _deadline = null);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id,
      title: _titleC.text.trim(),
      content: _contentC.text.trim(),
      createdAt: widget.note?.createdAt ?? now,
      deadline: _deadline,
    );

    if (_isEdit) {
      await NoteDb.instance.update(note.id!, note.toMap());
    } else {
      await NoteDb.instance.insert(note.toMap());
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deadlineText = _deadline == null
        ? '-'
        : DateFormat('dd MMM yyyy').format(_deadline!);

    final previewColor = _deadline == null
        ? Colors.grey.shade300
        : _deadline!.isBefore(DateTime.now())
        ? Colors.red.shade200
        : Colors.green.shade200;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Note' : 'Tambah Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Preview warna (berdasarkan deadline)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleC,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _contentC,
                decoration: const InputDecoration(
                  labelText: 'Isi',
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 8,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Isi wajib' : null,
              ),
              const SizedBox(height: 16),

              Text('Deadline: $deadlineText'),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickDeadline,
                      child: const Text('Pilih Deadline'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearDeadline,
                      child: const Text('Hapus Deadline'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
