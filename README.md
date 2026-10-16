# شريان (Sharyan) — Flutter frontend (UI only)

Frontend-only Flutter/Dart implementation of the Sharyan blood-donation platform
designs. **No backend, API, database or real authentication.** Everything uses
mock data and in-memory state (reset on restart). Only dependencies:
`flutter`, `flutter_localizations` (both ship with the SDK).

## Run it
```bash
flutter create --project-name sharyan_app --platforms=web,windows,android,ios .   # once, in this folder
flutter pub get
flutter analyze
flutter test
flutter run -d chrome        # or: -d windows / an emulator
```
(`flutter create .` only adds the platform folders; it keeps `lib/`, `test/`, `pubspec.yaml`.
If it overwrites `pubspec.yaml`/`test/widget_test.dart`, re-copy them from this archive.)

Optional: bundle the Cairo font (see comment in `pubspec.yaml`) for a closer match to Figma.

## Demo data
- Login: `example@gmail.com` (or `+201012345678`) / `12345678`
- Unknown email → "غير مسجل"; wrong password → "كلمة السر غير صحيحة"
- Forgot-password OTP: `123456` (shown on the screen; nothing is sent)
- Registered accounts live only until the app restarts

## Screen map (Figma → Flutter)
| Figma | Screen | File |
|---|---|---|
| Frame 1 | Home | `screens/home_screen.dart` |
| Donor guide | دليل المتبرع | `screens/donor_guide_screen.dart` |
| Frame 14 | استمارة طلب الدم | `screens/blood_request_form_screen.dart` |
| Frame 15 | استمارة التبرع | `screens/donation_form_screen.dart` |
| Frame 3 / 4 | Login / Register | `login_screen.dart`, `register_screen.dart` |
| Frame 5 / 6 / 7 | Forgot / OTP / Reset | `forgot_password_screen.dart`, `otp_screen.dart`, `reset_password_screen.dart` |
| Frame 9 | لوحة التحكم | `dashboard_screen.dart` |
| Frame 8 | طلبات الدم | `blood_requests_screen.dart` |
| Frame 10 | احجز معادك | `book_appointment_screen.dart` |
| Profile | ملفي الشخصي | `profile_screen.dart` |
| Centers | مراكز التبرع | `donation_centers_screen.dart` |
| Frames 13/16/17 | Success screens | `success_screen.dart` |

## Flow
Home → Login (back → Home) → Dashboard. Login → Register → (success) Login.
Login → Forgot → OTP → New password → Login. Every success screen: «حسناً» →
Dashboard (or Home if not logged in). Logout → Login. Dashboard pages are guarded.

## Responsive
Breakpoints: phone < 600, tablet < 1024, desktop ≥ 1024. Public navbar → drawer below 1000px;
dashboard sidebar → drawer on phones; forms/grids reflow; content max-width 1400 for 1920×1080.
`test/widget_test.dart` renders every screen at 390, 820 and 1920 px.

## Decisions to confirm (ambiguities)
1. **Booking stepper**: Figma shows only step 1 with branch+date+time. Implemented 4 steps
   (branch → date → time → confirm summary). Easy to change.
2. **«طلبات الدم» in the sidebar** is the list with filters (as in Figma). The request *form* is
   reached from the public «طلب الدم» link or the «طلب دم جديد» button I added on the list page.
3. **Home buttons**: «ابدأ الان» → donation form, «معرفة المزيد» → donor guide, cards → donate /
   booking / requests list; «ساعد في المجتمع» and the search icon show a "not available" dialog.
4. **No design provided** for request details, center details, directions, edit profile:
   simple dialogs / in-place edit / "unavailable in demo" message.
5. Register button says «إنشاء حساب» (Figma shows «تسجيل الدخول», likely a copy-paste slip);
   OTP header typo «التحقيق» fixed to «التحقق».
6. Compatibility table uses correct ABO/Rh rules (the Figma table has a few duplicate chips).
7. Donation form keeps its original single page (no steps removed). Added validation: age 18–65,
   weight ≥ 50 kg, matching the donor guide.
8. Hero photo / logo are icon-based stand-ins; replace with exported Figma assets if wanted.

## Verification status
Written without a Flutter SDK available, so `flutter analyze` / `flutter test` have **not**
been run on this code. Run them locally and send me any errors to fix.
