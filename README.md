# פרויקט Drupal עם Docker

## חברי הצוות

- רז מצליח
- בן פישר

## הקשר הקורס

פרויקט מסכם בקורס כלי פיתוח, מכללת אפקה, הנדסת תוכנה, שנה א׳ סמסטר ב׳.

## מה התבקשנו לעשות

בפרויקט התבקשנו להקים אתר Drupal פשוט בעזרת Docker, לחבר אותו למסד נתונים MySQL, ולהוסיף סקריפטים לגיבוי, שחזור, ניקוי ותיעוד של הפרויקט.

## מה עשינו

יצרנו סביבת Docker הכוללת:

- רשת Docker בשם `afeka-drupal-network`
- קונטיינר MySQL בשם `afeka-mysql-db`
- קונטיינר Drupal בשם `afeka-drupal-site`
- volumes לשמירת נתוני MySQL ונתוני Drupal
- סקריפט הקמה: `setup.sh`
- סקריפט גיבוי: `backup.sh`
- סקריפט שחזור: `restore.sh`
- סקריפט ניקוי: `cleanup.sh`

## טכנולוגיות

- Docker
- Drupal
- MySQL
- Bash
- Git
- GitHub

## מדריך הפעלה מלא

### 1. שכפול הפרויקט

```bash
git clone https://github.com/Afeka-DevTools/26b-10142-unittesting-raz_ben.git
```

### 2. כניסה לתיקיית הפרויקט

```bash
cd 26b-10142-unittesting-raz_ben
```

### 3. מתן הרשאות הרצה לסקריפטים

```bash
chmod +x setup.sh backup.sh restore.sh cleanup.sh
```

### 4. הקמת סביבת Docker

```bash
./setup.sh
```

הסקריפט יוצר רשת Docker, volumes, קונטיינר MySQL וקונטיינר Drupal.

### 5. פתיחת האתר בדפדפן

לאחר ההרצה פותחים את האתר:

```text
http://localhost:8080
```

### 6. פרטי התקנת Drupal

במסך ההתקנה של Drupal יש לבחור MySQL ולהזין את הפרטים הבאים:

```text
Database type: MySQL
Database host: afeka-mysql-db
Database name: drupal_db
Database user: drupal_user
Database password: drupal_pass
Site name: האתר של רז מצליח ובן פישר
Admin username: demoadmin
Admin password: secretpass
```

### 7. יצירת משתמשים לחברי הצוות

לאחר סיום התקנת Drupal:

1. נכנסים לממשק הניהול עם המשתמש `demoadmin`.
2. נכנסים ל-`People`.
3. לוחצים על `Add user`.
4. יוצרים משתמש עבור רז מצליח ומשתמש עבור בן פישר.
5. שומרים את המשתמשים.

### 8. הוספת תוכן מילון מונחים לקורס

כדי להוסיף תוכן ידני לאתר:

1. נכנסים לממשק הניהול של Drupal.
2. נכנסים ל-`Content`.
3. לוחצים על `Add content`.
4. יוצרים עמודים או מאמרים עם מונחים מהקורס כלי פיתוח.
5. בכל פריט תוכן מוסיפים כותרת, הסבר קצר ודוגמה אם צריך.
6. שומרים את התוכן.

### 9. יצירת גיבוי

לאחר שהאתר ומסד הנתונים קיימים, מריצים:

```bash
./backup.sh
```

הגיבוי נשמר בקובץ:

```text
backups/my-drupal.backup.sql.gz
```

אם הקובץ לא קיים עדיין, הוא ייווצר אחרי הרצת `./backup.sh`.

### 10. שחזור מגיבוי

כדי לשחזר את מסד הנתונים מהגיבוי:

```bash
./restore.sh
```

הסקריפט משחזר את הקובץ `backups/my-drupal.backup.sql.gz` ומפעיל מחדש את קונטיינר Drupal.

### 11. ניקוי הפרויקט

כדי למחוק את סביבת Docker של הפרויקט:

```bash
./cleanup.sh
```

חשוב: הסקריפט מוחק את הקונטיינרים, התמונות, ה-volumes והרשת של הפרויקט. לכן הוא מבקש אישור לפני המחיקה. כדי להמשיך צריך להקליד `yes`.

## שמות והגדרות קבועים בפרויקט

```text
Drupal URL: http://localhost:8080
Docker network: afeka-drupal-network
Drupal container: afeka-drupal-site
MySQL container: afeka-mysql-db
Database name: drupal_db
Database user: drupal_user
Database password: drupal_pass
MySQL root password: my-secret-pw
Backup file: backups/my-drupal.backup.sql.gz
```
