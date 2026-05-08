import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';

/// Belirli bir hearing'e ait kullanıcı notlarını listeleyen + ekleme/silme
/// imkanı sunan reusable widget.
class NotesSection extends ConsumerStatefulWidget {
  const NotesSection({required this.hearingId, super.key});

  final int hearingId;

  @override
  ConsumerState<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends ConsumerState<NotesSection> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);
    final db = ref.read(appDatabaseProvider);
    await db.userNotesDao.add(UserNotesCompanion.insert(
      hearingId: Value(widget.hearingId),
      notMetni: text,
      olusturmaTarihi: DateTime.now().toUtc(),
    ));
    _controller.clear();
    if (mounted) setState(() => _saving = false);
    ref.invalidate(_notesProvider(widget.hearingId));
  }

  Future<void> _delete(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.userNotesDao.deleteById(id);
    ref.invalidate(_notesProvider(widget.hearingId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncNotes = ref.watch(_notesProvider(widget.hearingId));
    final fmt = DateFormat('dd.MM.yyyy HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Yeni not ekle…',
            border: const OutlineInputBorder(),
            isDense: true,
            suffixIcon: IconButton(
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              onPressed: _saving ? null : _add,
            ),
          ),
        ),
        const SizedBox(height: 12),
        asyncNotes.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
          error: (e, _) => Text('Notlar yüklenemedi: $e'),
          data: (notes) {
            if (notes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Bu duruşmaya henüz not eklenmedi.',
                  style: theme.textTheme.bodySmall,
                ),
              );
            }
            return Column(
              children: [
                for (final n in notes)
                  Card(
                    child: ListTile(
                      title: Text(n.notMetni),
                      subtitle: Text(fmt.format(n.olusturmaTarihi.toLocal())),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _delete(n.id),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

final _notesProvider =
    FutureProvider.family<List<UserNote>, int>((ref, hearingId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.userNotesDao.byHearingId(hearingId);
});
