# תרגיל בית 2 - בדיקות יחידה ב-Java עם Gradle

מאגר זה הוא ההגשה הקבוצתית של תרגיל בית 2 בקורס כלי פיתוח. הוא כולל בדיקות
יחידה עבור כל הפונקציות הציבוריות בקובץ `App.java`, בנייה באמצעות Gradle,
בדיקת כיסוי אוטומטית ותיעוד השימוש ב-LLM.

## חברי הצוות

| שם | GitHub |
| --- | --- |
| רז מצליח | `razmazlih` |
| בן פישר | `Benjamin-1Fisher` |
| עומרי בוגוסלבסקי | — |

## מבנה המטלה

```text
.
├── app/
│   └── src/
│       ├── main/java/org/example/App.java
│       └── test/java/org/example/AppTest.java
├── chats/
│   ├── LEARNING.md
│   └── COPILOT.md
├── logs/
│   ├── LEARNING.md
│   └── COPILOT.md
├── gradlew
└── README.md
```

## דרישות מוקדמות

- JDK 21
- Git

אין צורך להתקין Gradle בנפרד: המאגר כולל Gradle Wrapper.

## שכפול והרצת הבדיקות

```bash
git clone https://github.com/Afeka-DevTools/26b-10142-unittesting-raz_ben.git
cd 26b-10142-unittesting-raz_ben
./gradlew clean check
```

ב-Windows יש להריץ:

```bat
gradlew.bat clean check
```

הפקודה `check` מהדרת את הקוד, מריצה את כל בדיקות JUnit 5, ומאמתת באמצעות
JaCoCo כיסוי של 100% לשורות ולענפים. דוח הבדיקות נוצר תחת
`app/build/reports/tests/test/`, ודוח הכיסוי נוצר תחת
`app/build/reports/jacoco/test/html/index.html`.

להרצת הבדיקות בלבד:

```bash
./gradlew test
```

## מה נבדק

`app/src/test/java/org/example/AppTest.java` מכסה את כל 11 המתודות הציבוריות
ב-`App.java`:

- `add`
- `isPrime`
- `reverse`
- `factorial`
- `isPalindrome`
- `fibonacciUpTo`
- `charFrequency`
- `isAnagram`
- `average`
- `filterEvens`
- `mostCommonWord`

הבדיקות כוללות קלטים תקינים, ערכי גבול, קלטים שליליים, קלט ריק, חריגות,
רישיות, רווחים, סימני פיסוק ושימור סדר ברשימות. נעשה שימוש ב-Assertions
מגוונים של JUnit 5: `assertEquals`, `assertTrue`, `assertFalse`,
`assertThrows`, `assertAll`, `assertIterableEquals`, `assertNotNull` ו-
`assertDoesNotThrow`.

## בדיקת כיסוי ונתיבי קוד

כללי JaCoCo ב-`app/build.gradle.kts` מכשילים את `./gradlew check` אם כיסוי
השורות או הענפים של `App.java` נמוך מ-100%. ההרצה המאומתת האחרונה כיסתה
46 מתוך 46 שורות ו-26 מתוך 26 ענפים.

## תיעוד שימוש ב-LLM

ההגשה כוללת את כל קבצי התיעוד הנדרשים:

- `logs/LEARNING.md` - תיעוד הלמידה מחלק 2.
- `logs/COPILOT.md` - תיעוד תכנון וביקורת הבדיקות מחלק 3.
- `chats/LEARNING.md` ו-`chats/COPILOT.md` - עותקי השיחות שנשמרו במאגר.

המלצות ה-LLM נבדקו מול הקוד ובאמצעות `./gradlew clean check`; הן לא הוגשו
ללא אימות אוטומטי של הבדיקות וכיסוי הנתיבים.
