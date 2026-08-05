This repo has two independent apps:

- **Desktop (Python)**: `standalone.py` (Tkinter GUI + console fallback), backed by shared logic in `core.py`. Console and GUI modes must stay feature compatible. Before committing changes here, run `python -m unittest`.
- **Web (Flutter)**: `app/`, a Flutter Web app deployed to GitHub Pages via `.github/workflows/deploy.yml`. It calls the AwesomeAPI/brapi.dev APIs directly from the browser and has no server or database — user watchlists are persisted client-side (localStorage) via `shared_preferences`. Before committing changes here, run `flutter analyze` and `flutter test` inside `app/`.

The two apps duplicate the same domain logic (currency conversion, weekly profit simulator, B3 stocks) in their respective languages; keep them behaviorally equivalent when adding features, but there is no shared code between them.
