import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_scope.dart';
import 'data.dart';
import 'theme.dart';
import 'ios_frame.dart';
import 'screens/onboarding.dart';
import 'screens/auth.dart';
import 'screens/personalize.dart';
import 'screens/home.dart';
import 'screens/ai.dart';
import 'screens/search.dart';
import 'screens/product.dart';
import 'screens/image_search.dart';
import 'screens/for_you.dart';
import 'screens/local.dart';
import 'screens/saved.dart';
import 'screens/account.dart';
import 'screens/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-warm fonts so text doesn't re-layout mid-navigation.
  GoogleFonts.config.allowRuntimeFetching = true;
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.manrope(),
      GoogleFonts.playfairDisplay(),
    ]).timeout(const Duration(seconds: 3));
  } catch (_) {/* offline / slow - fall back to runtime load */}
  runApp(LibasAIApp(state: AppState()));
}

class LibasAIApp extends StatelessWidget {
  final AppState state;
  const LibasAIApp({super.key, required this.state});

  static final Map<String, WidgetBuilder> _routes = {
    '/splash': (_) => const SplashScreen(),
    '/onboard1': (_) => const OnboardingScreen(step: 1),
    '/onboard2': (_) => const OnboardingScreen(step: 2),
    '/onboard3': (_) => const OnboardingScreen(step: 3),
    '/welcome': (_) => const WelcomeScreen(),
    '/signup': (_) => const SignUpScreen(),
    '/signin': (_) => const SignInScreen(),
    '/forgotpw': (_) => const ForgotPasswordScreen(),
    '/pref1': (_) => const PreferenceStep(step: 1),
    '/pref2': (_) => const PreferenceStep(step: 2),
    '/pref3': (_) => const PreferenceStep(step: 3),
    '/home': (_) => const HomeScreen(),
    '/aiEmpty': (_) => const AiEmptyScreen(),
    '/aiChat': (_) => const AiChatScreen(),
    '/aiProcessing': (_) => const AiProcessingScreen(),
    '/aiResults': (_) => const AiResultsScreen(),
    '/search': (_) => const SearchScreen(),
    '/searchResults': (_) => const SearchResultsScreen(),
    '/filters': (_) => const FiltersScreen(),
    '/sortSheet': (_) => const SortSheetScreen(),
    '/productDetail': (_) => const ProductDetailScreen(),
    '/imageGallery': (_) => const ImageGalleryScreen(),
    '/productComparison': (_) => const ProductComparisonScreen(),
    '/imageSearchIntro': (_) => const ImageSearchIntroScreen(),
    '/imagePreview': (_) => const ImagePreviewScreen(),
    '/imageScanning': (_) => const ImageScanningScreen(),
    '/imageResults': (_) => const ImageResultsScreen(),
    '/recommendations': (_) => const RecommendationsScreen(),
    '/outfitBuilder': (_) => const OutfitBuilderScreen(),
    '/outfitResult': (_) => const OutfitResultScreen(),
    '/discoverLocal': (_) => const DiscoverLocalScreen(),
    '/brandProfile': (_) => const BrandProfileScreen(),
    '/wishlist': (_) => const WishlistScreen(),
    '/recentlyViewed': (_) => const RecentlyViewedScreen(),
    '/searchHistory': (_) => const SearchHistoryScreen(),
    '/savedLooks': (_) => const SavedLooksScreen(),
    '/profile': (_) => const ProfileScreen(),
    '/myPreferences': (_) => const MyPreferencesScreen(),
    '/settings': (_) => const SettingsScreen(),
    '/statesGallery': (_) => const StatesGalleryScreen(),
  };

  static const _darkScreens = {'/splash', '/aiProcessing', '/imageScanning', '/imageGallery'};

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'LibasAI',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        initialRoute: '/splash',
        builder: (context, child) => IOSFrameHost(child: child ?? const SizedBox()),
        onGenerateRoute: (settings) {
          final builder = _routes[settings.name] ?? _routes['/home']!;
          final dark = _darkScreens.contains(settings.name);
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, a1, a2) {
              SystemChrome.setSystemUIOverlayStyle(
                  dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
              return IOSFrame(dark: dark, child: builder(context));
            },
            transitionsBuilder: (context, anim, sec, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
