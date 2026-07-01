# פרויקט Drupal ב-Docker - רז מצליח ובן פישר

## מי אנחנו

- רז מצליח
- בן פישר

פרויקט מסכם בקורס DevTools, מכללת אפקה, הנדסת תוכנה, שנה א׳ סמסטר ב׳.

## מה נדרשנו לעשות

נדרשנו ליצור אתר Drupal בעזרת Docker, לחבר אותו למסד נתונים MySQL, ליצור אפשרויות גיבוי ושחזור, ליצור סקריפט ניקוי, ולתעד הכל בקובץ README.

## מה עשינו

יצרנו רשת Docker, קונטיינר MySQL, קונטיינר Drupal, Docker volumes, סקריפט הקמה, סקריפט גיבוי, סקריפט שחזור, סקריפט ניקוי ותיעוד לפרויקט.

## טכנולוגיות

- Docker
- Drupal
- MySQL
- Bash
- Git
- GitHub

## מבנה הקבצים בפרויקט

```text
.
├── setup.sh
├── backup.sh
├── restore.sh
├── cleanup.sh
├── README.md
├── backups/
│   └── .gitkeep
└── backups/my-drupal.backup.sql.gz
```

הקובץ `backups/my-drupal.backup.sql.gz` לא נוצר ידנית. הוא נוצר רק אחרי התקנת Drupal והרצת `./backup.sh`.

## הוראות הפעלה Step By Step

```bash
git clone https://github.com/Afeka-DevTools/26b-10142-unittesting-raz_ben.git
cd 26b-10142-unittesting-raz_ben
chmod +x setup.sh backup.sh restore.sh cleanup.sh
./setup.sh
```

לאחר הרצת `setup.sh`, פותחים בדפדפן:

```bash
http://localhost:8080
```

## הגדרת Drupal בדפדפן

במסך ההתקנה של Drupal יש לבחור MySQL ולהשתמש בפרטים הבאים:

```text
Database type:
MySQL

Database host:
afeka-mysql-db

Database port:
3306

Database name:
drupal_db

Database user:
drupal_user

Database password:
drupal_pass

Site name:
האתר של רז מצליח ובן פישר

Admin username:
demoadmin

Admin password:
secretpass
```

חשוב: חשבון המנהל `demoadmin` נוצר ידנית בזמן התקנת Drupal בדפדפן.

משתמשים לחברי הצוות צריכים להיווצר ידנית בתוך Drupal אחרי סיום ההתקנה.

תוכן מילון המונחים של הקורס צריך להתווסף ידנית דרך ממשק הניהול של Drupal.

## גיבוי

לאחר שהאתר ומסד הנתונים קיימים, מריצים:

```bash
./backup.sh
```

הגיבוי נשמר בקובץ:

```text
backups/my-drupal.backup.sql.gz
```

## שחזור

כדי לשחזר את מסד הנתונים מהגיבוי:

```bash
./restore.sh
```

הסקריפט משחזר את הקובץ `backups/my-drupal.backup.sql.gz` ומפעיל מחדש את קונטיינר Drupal.

## ניקוי סביבת העבודה

כדי למחוק את סביבת Docker של הפרויקט:

```bash
./cleanup.sh
```

הסקריפט מבקש אישור לפני המחיקה. כדי להמשיך צריך להקליד בדיוק:

```text
yes
```

חשוב: cleanup מוחק את הקונטיינרים של הפרויקט, Docker images, רשת Docker ו-Docker volumes. מחיקת ה-volumes מוחקת גם את נתוני Drupal ו-MySQL שנשמרו בהם.

## הערות חשובות

- כתובת האתר: `http://localhost:8080`
- רשת Docker: `afeka-drupal-network`
- קונטיינר Drupal: `afeka-drupal-site`
- קונטיינר MySQL: `afeka-mysql-db`
- Volume של MySQL: `afeka-mysql-data`
- Volume של Drupal: `afeka-drupal-data`
- שם מסד הנתונים: `drupal_db`
- משתמש מסד הנתונים: `drupal_user`
- סיסמת מסד הנתונים: `drupal_pass`
- סיסמת root של MySQL: `my-secret-pw`
- קובץ הגיבוי: `backups/my-drupal.backup.sql.gz`
- הפרויקט משתמש בפקודות Docker רגילות ובסקריפטים פשוטים ב-Bash.
- אין ליצור קובץ גיבוי מזויף. קובץ הגיבוי האמיתי נוצר רק אחרי התקנת Drupal והרצת `./backup.sh`.
