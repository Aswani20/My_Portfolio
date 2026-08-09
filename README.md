# Portfolio App (Flutter Web)

## Structure
```
lib/
  main.dart                 # entry point
  app.dart                  # assembles all sections into the scrollable page
  theme/
    app_theme.dart          # colors, text styles, spacing, breakpoints
  widgets/
    common/
      section_container.dart  # shared wrapper for consistent section padding
      cta_buttons.dart         # PrimaryButton / SecondaryButton
      app_navbar.dart          # sticky top nav: links, theme toggle, CV download
    sections/
      hero_section.dart       # built: name, title, tagline, photo, CTAs
      about_section.dart      # placeholder
      skills_section.dart     # placeholder
      projects_section.dart   # placeholder
      experience_section.dart # placeholder
      contact_section.dart    # placeholder
  models/                    # data classes (e.g. Project, Skill) go here
  utils/
    file_download.dart        # cross-platform export switch
    file_download_web.dart    # real browser download (dart:html)
    file_download_stub.dart   # no-op fallback for non-web
assets/
  images/                    # put your photos/logos here
web/
  index.html
  cv.pdf                     # PLACEHOLDER — replace with your real CV
```

## Personalize
- **Hero text**: edit the constants at the top of `lib/widgets/sections/hero_section.dart`
- **Profile photo**: add `assets/images/profile.jpg`
- **CV**: replace `web/cv.pdf` with your real file (keep the same filename, or update `cvUrl`/`cvDownloadFilename` in `lib/widgets/common/app_navbar.dart`)
- **Nav labels**: edit the `navItems` map in `app_navbar.dart`

## Run locally
Since this build environment doesn't have the Flutter SDK, run these on your machine:

```bash
flutter pub get
flutter run -d chrome
```

## Build for deployment
```bash
flutter build web
```
The output goes to `build/web/` — deploy that folder to any static host
(GitHub Pages, Netlify, Vercel, Firebase Hosting, etc.).

## Status
- [x] Project structure
- [x] Navigation bar (section links, back-to-top, light/dark toggle, CV download)
- [x] Hero section
- [ ] About section
- [ ] Skills section
- [ ] Projects section
- [ ] Experience section
- [ ] Contact section
- [ ] Responsive polish
