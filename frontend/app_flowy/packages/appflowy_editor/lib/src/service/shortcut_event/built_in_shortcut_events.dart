// List<>

import 'package:appflowy_editor/src/service/internal_key_event_handlers/arrow_keys_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/backspace_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/copy_paste_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/enter_without_shift_in_text_node_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/page_up_down_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/redo_undo_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/select_all_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/slash_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/format_style_handler.dart';
import 'package:appflowy_editor/src/service/internal_key_event_handlers/whitespace_handler.dart';
import 'package:appflowy_editor/src/service/shortcut_event/shortcut_event.dart';

//
List<ShortcutEvent> builtInShortcutEvents = [
  ShortcutEvent(
    key: 'Move cursor up',
    command: 'arrow up',
    handler: cursorUp,
  ),
  ShortcutEvent(
    key: 'Move cursor down',
    command: 'arrow down',
    handler: cursorDown,
  ),
  ShortcutEvent(
    key: 'Move cursor left',
    command: 'arrow left',
    handler: cursorLeft,
  ),
  ShortcutEvent(
    key: 'Move cursor right',
    command: 'arrow right',
    handler: cursorRight,
  ),
  ShortcutEvent(
    key: 'Cursor up select',
    command: 'shift+arrow up',
    handler: cursorUpSelect,
  ),
  ShortcutEvent(
    key: 'Cursor down select',
    command: 'shift+arrow down',
    handler: cursorDownSelect,
  ),
  ShortcutEvent(
    key: 'Cursor left select',
    command: 'shift+arrow left',
    handler: cursorLeftSelect,
  ),
  ShortcutEvent(
    key: 'Cursor right select',
    command: 'shift+arrow right',
    handler: cursorRightSelect,
  ),
  ShortcutEvent(
    key: 'Move cursor top',
    command: 'meta+arrow up',
    windowsCommand: 'ctrl+arrow up',
    handler: cursorTop,
  ),
  ShortcutEvent(
    key: 'Move cursor bottom',
    command: 'meta+arrow down',
    windowsCommand: 'ctrl+arrow down',
    handler: cursorBottom,
  ),
  ShortcutEvent(
    key: 'Move cursor begin',
    command: 'meta+arrow left',
    windowsCommand: 'ctrl+arrow left',
    handler: cursorBegin,
  ),
  ShortcutEvent(
    key: 'Move cursor end',
    command: 'meta+arrow right',
    windowsCommand: 'ctrl+arrow right',
    handler: cursorEnd,
  ),
  ShortcutEvent(
    key: 'Cursor top select',
    command: 'meta+shift+arrow up',
    windowsCommand: 'ctrl+shift+arrow up',
    handler: cursorTopSelect,
  ),
  ShortcutEvent(
    key: 'Cursor bottom select',
    command: 'meta+shift+arrow down',
    windowsCommand: 'ctrl+shift+arrow down',
    handler: cursorBottomSelect,
  ),
  ShortcutEvent(
    key: 'Cursor begin select',
    command: 'meta+shift+arrow left',
    windowsCommand: 'ctrl+shift+arrow left',
    handler: cursorBeginSelect,
  ),
  ShortcutEvent(
    key: 'Cursor end select',
    command: 'meta+shift+arrow right',
    windowsCommand: 'ctrl+shift+arrow right',
    handler: cursorEndSelect,
  ),
  ShortcutEvent(
    key: 'Redo',
    command: 'meta+shift+z',
    windowsCommand: 'ctrl+shift+z',
    handler: redoEventHandler,
  ),
  ShortcutEvent(
    key: 'Undo',
    command: 'meta+z',
    windowsCommand: 'ctrl+z',
    handler: undoEventHandler,
  ),
  ShortcutEvent(
    key: 'Format bold',
    command: 'meta+b',
    windowsCommand: 'ctrl+b',
    handler: formatBoldEventHandler,
  ),
  ShortcutEvent(
    key: 'Format italic',
    command: 'meta+i',
    windowsCommand: 'ctrl+i',
    handler: formatItalicEventHandler,
  ),
  ShortcutEvent(
    key: 'Format underline',
    command: 'meta+u',
    windowsCommand: 'ctrl+u',
    handler: formatUnderlineEventHandler,
  ),
  ShortcutEvent(
    key: 'Format strikethrough',
    command: 'meta+shift+s',
    windowsCommand: 'ctrl+shift+s',
    handler: formatStrikethroughEventHandler,
  ),
  ShortcutEvent(
    key: 'Format highlight',
    command: 'meta+shift+h',
    windowsCommand: 'ctrl+shift+h',
    handler: formatHighlightEventHandler,
  ),
  ShortcutEvent(
    key: 'Format link',
    command: 'meta+k',
    windowsCommand: 'ctrl+k',
    handler: formatLinkEventHandler,
  ),
  ShortcutEvent(
    key: 'Copy',
    command: 'meta+c',
    windowsCommand: 'ctrl+c',
    handler: copyEventHandler,
  ),
  ShortcutEvent(
    key: 'Paste',
    command: 'meta+v',
    windowsCommand: 'ctrl+v',
    handler: pasteEventHandler,
  ),
  ShortcutEvent(
    key: 'Paste',
    command: 'meta+x',
    windowsCommand: 'ctrl+x',
    handler: cutEventHandler,
  ),
  // TODO: split the keys.
  ShortcutEvent(
    key: 'Delete Text',
    command: 'delete,backspace',
    handler: deleteTextHandler,
  ),
  ShortcutEvent(
    key: 'selection menu',
    command: 'slash',
    handler: slashShortcutHandler,
  ),
  ShortcutEvent(
    key: 'enter',
    command: 'enter',
    handler: enterWithoutShiftInTextNodesHandler,
  ),
  ShortcutEvent(
    key: 'markdown',
    command: 'space',
    handler: whiteSpaceHandler,
  ),
  ShortcutEvent(
    key: 'select all',
    command: 'meta+a',
    windowsCommand: 'ctrl+a',
    handler: selectAllHandler,
  ),
  ShortcutEvent(
    key: 'page up / page down',
    command: 'page up,page down',
    handler: pageUpDownHandler,
  ),
];
