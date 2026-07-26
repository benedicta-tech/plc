# Claude Memory for PLC App

## Daily Reading Feature

### Implementation Details
- **Feature**: Daily liturgical readings (Liturgia Diária)
- **Data Source**: Google Sheets - "Liturgia Diaria" worksheet in main sheet
- **Pattern**: Uses the generic features library (same as Secretary, Parishes, About features)
- **Cache Duration**: 1 day (configurable in DI container)

### Google Sheets Column Mapping
```
Data -> date (also used as ID)
Identificacao -> id (fallback)
Tempo litugico -> title
Cor -> color (liturgical color: roxo, branco, vermelho, verde, rosa)
Detalhe -> details
Leituras -> readings
Corpo -> body
```

### Architecture
- **Entity**: `lib/features/daily_reading/domain/entities/daily_reading.dart`
- **Details parser**: `lib/features/daily_reading/domain/entities/liturgy_details.dart`
- **Body parser**: `lib/features/daily_reading/domain/entities/liturgy_body.dart`
- **Model**: `lib/features/daily_reading/data/models/daily_reading_model.dart`
- **Page**: `lib/features/daily_reading/presentation/pages/daily_reading_page.dart`
- **Widget**: `lib/features/daily_reading/presentation/widgets/daily_reading_card.dart`
- **Shared UI**: `lib/features/daily_reading/presentation/widgets/liturgy_header.dart`
  (`LiturgyHeader`, `LiturgyStole`, `LiturgyReadingChips`, `formatLiturgyDate`, `liturgyColor`)
  used by both the home card (`compact: true`) and the detail page
- **Body UI**: `lib/features/daily_reading/presentation/widgets/liturgy_block_view.dart`
  renders one `LiturgyBlock` (section, epigraph, refrain, verse, paragraph)
- **BLoC**: Reuses `GenericListBloc<DailyReading, String>`

### Key Features
1. **Home Page Card**: Shows today's reading with:
   - Liturgical stole image from the `Detalhe` HTML, falling back to a colored circle from `Cor`
   - Date, title (with liturgical year) and the italic note parsed by `LiturgyDetails`
   - Readings rendered as chips
   - Gradient background, tappable to navigate to detail page

2. **Detail Page**: `ListView` with the same header (stole, date, title, note, reading chips,
   liturgical color) followed by the full liturgy parsed from `Corpo`:
   centered section titles, right-aligned italic epigraphs, highlighted psalm refrains and
   numbered verses. Empty and error states with retry option.

3. **HTML Handling** (package `html`, no `flutter_html`):
   - `Detalhe`: `LiturgyDetails.parse()` → title, subtitle, note, readings, stole URL
   - `Corpo`: `parseLiturgyBody()` → `List<LiturgyBlock>` with bold/red spans preserved;
     `display: none` blocks, `<meta>` and images are dropped; a centered text longer than
     60 chars is a pastoral rubric, not a heading
   - `Leituras` is not rendered: it repeats the references already shown as chips

4. **Real data test**: `test/features/daily_reading/real_data_test.dart` runs both parsers
   against `test/examples/exemple-liturgia-diaria.tsv` (~1 year of the real spreadsheet).
   Run it after any parser change.

### Color Mapping
- roxo/purple → Purple
- branco/white → White (special handling for icon color)
- vermelho/red → Red
- verde/green → Green
- rosa/pink → Pink
- Default: Grey

### Date Handling
- `date` is a `DateTime`; today's reading is matched with `DateUtils.isSameDay` (never compare it to a `String`)
- Falls back to first reading if today's not found
- Displays date as "{Day of week}, {day} de {Month} de {year}" in Portuguese

### DI Registration
- Remote data source: `GenericGSheetsDataSource<DailyReadingModel>`
- Local data source: `GenericLocalDataSourceImpl<DailyReadingModel>`
- Repository: `GenericCachedRepository<DailyReading, DailyReadingModel>`
- BLoC: `GenericListBloc<DailyReading, String>` (registered in main.dart)

### Notes
- No custom use cases or repositories needed (uses generic implementations)
- Total implementation: ~500 lines across 4 files
- Follows the 70% code reduction pattern from generic features library
