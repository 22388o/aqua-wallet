import 'dart:async';

import 'package:aqua/config/config.dart';
import 'package:aqua/constants.dart';
import 'package:aqua/features/lightning/lightning.dart';
import 'package:aqua/features/lightning/widgets/lightning_status_text.dart';
import 'package:aqua/features/shared/shared.dart';
import 'package:aqua/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

const _slideAnimationDuration = Duration(milliseconds: 300);
const _scaleAnimationDuration = Duration(milliseconds: 300);
const _fadeAnimationDuration = Duration(milliseconds: 200);

class LightningTransactionSuccessScreen extends HookConsumerWidget {
  const LightningTransactionSuccessScreen({super.key});

  static const routeName = '/lightningTransactionSuccessScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as LightningSuccessArguments;

    final satoshiAmountFormatted = useMemoized(() {
      // TODO - remove the hardcoded 'en_US' but we need to be consistent
      // throughout the app
      return NumberFormat.decimalPattern('en_US')
          .format(arguments.satoshiAmount);
    });

    //ANCHOR - Force status bar colors
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 250), () {
        ref.read(systemOverlayColorProvider(context)).transparent();
      });
      return () => ref.read(systemOverlayColorProvider(context)).themeBased();
    }, []);

    //ANCHOR - Slide animation

    final slideAnimationController =
        useAnimationController(duration: _slideAnimationDuration);
    final slideAnimation = Tween(begin: const Offset(0, -3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.easeOutBack,
    ));

    useEffect(() {
      Future.delayed(
        _slideAnimationDuration,
        () => slideAnimationController.forward(),
      );
      return () => slideAnimationController.dispose();
    }, []);

    //ANCHOR - Scale animation

    final scaleAnimationController =
        useAnimationController(duration: _scaleAnimationDuration);
    final scaleAnimation = Tween(begin: 0.75, end: 1.0).animate(CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.elasticOut,
    ));

    slideAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideAnimationController.stop();
        scaleAnimationController.forward();
      }
    });

    //ANCHOR - Fade animation

    final fadeAnimationController =
        useAnimationController(duration: _fadeAnimationDuration);
    final fadeAnimation = useAnimation(CurvedAnimation(
      parent: fadeAnimationController,
      curve: Curves.easeOut,
    ));

    scaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scaleAnimationController.stop();
        fadeAnimationController.forward();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: fadeAnimation,
              duration: _fadeAnimationDuration,
              child: Column(
                children: [
                  SizedBox(height: 198.h),
                  //ANCHOR - Aqua Logo
                  SvgPicture.asset(
                    Svgs.aquaLogoWhite,
                    width: 200.w,
                  ),
                  const Spacer(),
                  //ANCHOR - Lightning Graphic Placeholder
                  SizedBox(height: 180.h),
                  //ANCHOR - Status Text
                  LightningStatusText(
                    type: arguments.type,
                    orderId: arguments.orderId,
                  ),
                  SizedBox(height: 18.h),
                  //ANCHOR - Amount
                  Text(
                    context.loc.lightningTransactionSuccessScreenAmountSats(
                        satoshiAmountFormatted),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 48.sp,
                        ),
                  ),
                  SizedBox(height: 18.h),
                  const Spacer(),
                  //ANCHOR - Button
                  SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(54.h),
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        side: BorderSide(
                          width: 2.w,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        context.loc.lightningTransactionSuccessScreenDoneButton,
                      ),
                    ),
                  ),
                  SizedBox(height: kBottomPadding + 12.h),
                ],
              ),
            ),
            //ANCHOR - Lightning Graphic
            Container(
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 120.h),
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: SvgPicture.asset(
                    Svgs.lightningBolt,
                    width: 240.r,
                    height: 240.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
