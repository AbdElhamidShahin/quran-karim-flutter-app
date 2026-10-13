import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/bloc/BlocCounterSapha.dart';
import '../../model/bloc/states.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';
import '../wedgit/CustomAppBar.dart';

class SephaScreen extends StatelessWidget {
  const SephaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'المسبحة',
          style: TextStyle(
            fontFamily: 'Lalezar',
            fontSize: 24,
            color: primaryColor,
            letterSpacing: 0.8,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (_) => CounterCubit(),
        child: const _TasbihBody(),
      ),
    );
  }
}

class _TasbihBody extends StatelessWidget {
  const _TasbihBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CounterCubit, PrayerState>(
      builder: (context, state) {
        final cubit = CounterCubit.get(context);
        final progress = cubit.count / 99.0;

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Current dhikr label ────────────────────────────────────
              _DhikrLabel(dhikr: cubit.Options()),

              const SizedBox(height: 8),

              // ── Tap hint ──────────────────────────────────────────────
              Text(
                'اضغط للعد',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: primaryLight.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 20),

              // ── Tappable bead ring ────────────────────────────────────
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      cubit.addNumber();
                    },
                    child: _AnimatedBeadRing(
                      count: cubit.count,
                      progress: progress,
                    ),
                  ),
                ),
              ),

              // ── Counter display ───────────────────────────────────────
              Text(
                '${cubit.count} / 99',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 6),

              // ── Progress bar ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Reset button (small, themed) ──────────────────────────
              _ResetButton(onTap: () async {
                final confirmed = await _confirmReset(context);
                if (confirmed) cubit.resultcount();
              }),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
      listener: (_, __) {},
    );
  }

  Future<bool> _confirmReset(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: surfaceDark,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'إعادة العداد',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              textDirection: TextDirection.rtl,
            ),
            content: const Text(
              'هل تريد إعادة العداد إلى الصفر؟',
              style: TextStyle(fontFamily: 'Cairo', color: primaryLight),
              textDirection: TextDirection.rtl,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء',
                    style: TextStyle(color: primaryLight, fontFamily: 'Cairo')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('إعادة',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ) ??
        false;
  }
}

/// Shows the current dhikr phrase in a pill badge
class _DhikrLabel extends StatelessWidget {
  final String dhikr;
  const _DhikrLabel({required this.dhikr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primaryColor.withOpacity(0.4)),
      ),
      child: Text(
        dhikr.trim(),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Bead ring that fills progressively as the count rises
class _AnimatedBeadRing extends StatelessWidget {
  final int count;
  final double progress;
  const _AnimatedBeadRing({required this.count, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer progress ring
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: primaryColor.withOpacity(0.12),
              color: primaryColor,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Bead image (tinted teal)
          SizedBox(
            width: 210,
            height: 210,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                primaryColor.withOpacity(0.75),
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/sebhaBody.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Tap ripple hint
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(130),
                splashColor: primaryColor.withOpacity(0.25),
                highlightColor: Colors.transparent,
                onTap: null, // gesture handled by GestureDetector above
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small, on-brand reset button — not a big white FAB
class _ResetButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ResetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: primaryColor.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.refresh_rounded, color: primaryLight, size: 20),
            SizedBox(width: 8),
            Text(
              'إعادة العداد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
