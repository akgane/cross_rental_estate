import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_estate_app/models/estate.dart';
import 'package:rental_estate_app/pages/estates_page/widgets/estate_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rental_estate_app/providers/auth_provider.dart' as AP;
import 'package:rental_estate_app/utils/sort_utils.dart';

class EstatesPage extends StatefulWidget{
  String title;
  List<Estate> estates;

  EstatesPage({super.key, required this.title, required this.estates});

  @override
  State<StatefulWidget> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage>{
  late List<Estate> _sortedEstates;
  String _currentSort = "title";
  bool _isAscending = true;

  @override
  void initState(){
    super.initState();
    _sortedEstates = [...widget.estates];
    _sortEstates(_currentSort);
  }

  void _sortEstates(String sortBy){
    setState(() {
      if (_currentSort == sortBy) {
        _isAscending = !_isAscending;
      } else {
        _currentSort = sortBy;
        _isAscending = true;
      }
      _sortedEstates = SortUtils.sortBy(sortBy, _sortedEstates, _isAscending);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final authProvider = Provider.of<AP.AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildSortButton(loc!.u_price, Icons.attach_money, "price"),
                _buildSortButton(loc.u_title, Icons.sort_by_alpha, "title"),
                _buildSortButton(loc.u_date, Icons.calendar_today, "date"),
                _buildSortButton(loc.u_views, Icons.visibility, "views"),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _sortedEstates.length,
                itemBuilder: (context, index) {
                  final estate = _sortedEstates[index];
                  bool isFavorite = authProvider.isGuest ? false : (authProvider.user!.favoriteEstates.contains(estate.uid));
                  return Column(
                      children: [
                        EstateCard(estate: estate, isFavorite: isFavorite,),
                        if(index < _sortedEstates.length - 1)
                          Column(
                              children: [
                                SizedBox(height: 8,),
                                Divider(
                                    height: 1,
                                    thickness: 0.5,
                                    color: theme.dividerColor
                                ),
                                SizedBox(height: 8,)
                              ]
                          )
                      ]
                  );
                },
              )
          )
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, IconData icon, String sortBy) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: () => _sortEstates(sortBy),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentSort == sortBy ? Colors.orange : Colors.grey[800],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 4,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        _currentSort == sortBy
            ? (_isAscending ? "$label ↑" : "$label ↓")
            : label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}