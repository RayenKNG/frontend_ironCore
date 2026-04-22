import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Reusable search bar widget.
class SearchInput extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const SearchInput({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search_rounded, size: 18, color: AppTheme.textHint),
          ),
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) {
                setState(() => _hasText = v.isNotEmpty);
                widget.onChanged(v);
              },
            ),
          ),
          if (_hasText)
            GestureDetector(
              onTap: () {
                _ctrl.clear();
                widget.onChanged('');
                setState(() => _hasText = false);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.close_rounded, size: 16, color: AppTheme.textHint),
              ),
            ),
        ],
      ),
    );
  }
}
