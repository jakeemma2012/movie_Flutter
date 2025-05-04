import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movieappprj/Function/_bottom_NAV.dart';
import 'package:movieappprj/Function/sideMenu_list.dart';
import 'package:movieappprj/Models/Movie.dart';
import 'package:movieappprj/Screen_New/_Detail_Movie.dart';
import 'package:movieappprj/Services/DatabaseService.dart';
import 'package:movieappprj/Services/ImageService.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

  final List<String> _searchHistory = [];
  bool _isSearching = false;

  List<Movie> allMovies = [];
  List<Movie> searchMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    allMovies = await DatabaseService.getAllMovie();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    print('Searching for: $query');
    print('Current allMovies count: ${allMovies.length}');

    setState(() {
      _isSearching = true;
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });

    setState(() {
      searchMovies =
          allMovies
              .where(
                (element) =>
                    element.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      print('Search results: ${searchMovies.length}');
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SideMenu(
      key: sideMenuKey,
      background: Colors.black.withOpacity(0.5),
      menu: SideMenuList(menuKey: sideMenuKey),
      child: Builder(
        builder: (context) {
          final isMenuOpen = sideMenuKey.currentState?.isOpened ?? false;
          return AbsorbPointer(
            absorbing: isMenuOpen,
            child: GestureDetector(
              onTap: () {
                if (isMenuOpen) {
                  sideMenuKey.currentState?.closeSideMenu();
                }
              },
              child: Scaffold(
                backgroundColor: dark ? Colors.black : Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      if (sideMenuKey.currentState?.isOpened ?? false) {
                        sideMenuKey.currentState?.closeSideMenu();
                      } else {
                        sideMenuKey.currentState?.openSideMenu();
                      }
                    },
                    icon: Icon(
                      Iconsax.menu_board,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                  title: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: dark ? Colors.grey[900] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search movies...',
                        hintStyle: TextStyle(
                          color: dark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Icon(
                          Iconsax.search_normal,
                          color: dark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color:
                                        dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      searchMovies.clear();
                                    });
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: _performSearch,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            searchMovies.clear();
                          });
                        } else {
                          _performSearch(value);
                        }
                      },
                    ),
                  ),
                ),
                body:
                    // _isSearching
                    // ? const Center(child: CircularProgressIndicator())
                    // : _searchController.text.isEmpty? _buildSearchHistory():
                    _buildSearchResults(),
                bottomNavigationBar: BottomNav(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchHistory() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Iconsax.clock,
                  color: dark ? Colors.grey[400] : Colors.grey[600],
                ),
                title: Text(
                  _searchHistory[index],
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                ),
                onTap: () {
                  _searchController.text = _searchHistory[index];
                  _performSearch(_searchHistory[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (searchMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_normal,
              size: 64,
              color: dark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${_searchController.text}"',
              style: TextStyle(
                fontSize: 18,
                color: dark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchMovies.length,
      itemBuilder: (context, index) {
        final movie = searchMovies[index];
        return Card(
          color: dark ? Colors.grey[900] : Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FutureBuilder<String>(
                future: ImageService.getAssets(movie.backdropUrl, "backdrop"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: dark ? Colors.grey[900] : Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: dark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data?.isEmpty == true) {
                    return Container(
                      width: 100,
                      height: 200,
                      color: dark ? Colors.grey[900] : Colors.grey[300],
                      child: Center(
                        child: Text(
                          movie.title[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ),
                    );
                  }
                  return Image.network(
                    snapshot.data!,
                    width: 100,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 200,
                        color: dark ? Colors.grey[900] : Colors.grey[300],
                        child: Center(
                          child: Text(
                            movie.title[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            title: Text(
              movie.title,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Rating: ${movie.rating}',
                  style: TextStyle(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMovie(movie: movie),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
