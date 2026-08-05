# תרגיל בית 2 - בדיקות יחידה ב-Java עם Gradle

מאגר זה כולל בדיקות יחידה עבור הפונקציות שבקובץ `App.java` במסגרת קורס כלי פיתוח.

## חברי הצוות

| שם | GitHub |
| --- | --- |
| רז מצליח | `razmazlih` |
| בן פישר | `Benjamin-1Fisher` |

## דרישות מוקדמות

- JDK 21
- Git

אין צורך להתקין Gradle בנפרד: המאגר כולל Gradle Wrapper.

## שכפול והרצת הבדיקות

```bash
git clone https://github.com/Afeka-DevTools/26b-10142-unittesting-raz_ben.git
cd 26b-10142-unittesting-raz_ben
bash ./gradlew clean check
```

ב-Windows יש להריץ:

```bat
gradlew.bat clean check
```

הפקודה `check` מריצה את כל בדיקות JUnit 5 ומאמתת כיסוי של 100% לשורות ולענפים באמצעות JaCoCo. דוח הבדיקות נוצר תחת `app/build/reports/tests/test/`, ודוח הכיסוי נמצא תחת `app/build/reports/jacoco/test/html/index.html`.

להרצת הבדיקות בלבד:

```bash
bash ./gradlew test
```

## מה נבדק

`app/src/test/java/org/example/AppTest.java` מכסה את כל 11 הפונקציות הציבוריות ב-`App.java`:

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

הבדיקות כוללות ערכי גבול, קלטים תקינים ולא תקינים, חריגות, מחרוזות ריקות, אותיות גדולות/קטנות, רווחים, סימני פיסוק ושימור סדר ברשימות. נעשה שימוש במגוון Assertions של JUnit 5, כולל `assertEquals`, `assertTrue`, `assertFalse`, `assertThrows`, `assertAll`, `assertIterableEquals`, `assertNotNull` ו-`assertDoesNotThrow`.

## בדיקת מסלולי הקוד

המשימה דורשת לבדוק שכל הנתיבים ומקרי הקצה מכוסים. לכן הוגדרו כללי JaCoCo ב-`app/build.gradle.kts` שמכשילים את `bash ./gradlew check` אם כיסוי השורות או הענפים נמוך מ-100%. ההגדרה מספקת אימות אוטומטי בנוסף לבדיקת מקרי הקצה הידנית.

## תיעוד שימוש ב-LLM

תיעוד השיחות נמצא בשתי התיקיות הנדרשות:

- `chats/` - תמלילי הלמידה ותהליך כתיבת הבדיקות.
- `logs/` - יומן ההגשה של חלקי הלמידה והסיוע בכתיבת הבדיקות.
