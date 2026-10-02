# termux-rtl

תיקון טקסט עברית/ערבית ב-Termux.

הטרמינל של Termux לא מריץ את אלגוריתם ה-BiDi של יוניקוד, ולכן עברית יוצאת
הפוך: אותיות בסדר הפוך, סוגריים ופסיקים במקום לא נכון, ובערבית אותיות נותקות.
הפרויקט מעביר את הפלט דרך `fribidi` + `arabic-reshaper` לפני שהוא מגיע למסך.

## התקנה

```sh
pkg install curl -y && curl -fsSL https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/install.sh | bash
```

## שימוש

```sh
git log | rtl                 # כל פקודה
rtl-exec claude               # סוכן קוד / כל פקודה, עם צבעים
echo "שלום" | rtl-clip        # העתקה ל-clipboard
```

`rtl` מסנן פלט של פקודה אחרת, `rtl-exec` מריץ פקודה בתוך pty (צבעים וסרגלי התקדמות
עובדים), ו-`rtl-clip` מעתיק טקסט RTL ללוח.

## הסרה

```sh
curl -fsSL https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/install.sh | bash -s -- --uninstall
```

## מגבלות

- הפתרון הזה מתקן **פלט**. הקלדה של עברית ישירות בשורת הפקודה עדיין מוצגת ללא BiDi,
  כי זה דבר שצריך תמיכה בתוך הטרמינל עצמו - לכן בדרך כלל כותבים באנגלית ומדביקים עם `rtl-clip`.
- שורות ארוכות מאוד עוברות לפי רמת embedding אחת; עורך כמו `vim`/`nano` לא ירוץ כמו שצריך דרך הפילטר.
- דרוש `fribidi` (מגיע מ-`pkg install`) ו-`python`. ערבית תופיע מחוברת רק עם `arabic-reshaper`.

## English

Termux has no BiDi engine, so RTL text renders backwards. This installs a
`fribidi`-based filter that reorders text (and joins Arabic letters) before it
hits the screen.

```sh
pkg install curl -y && curl -fsSL https://raw.githubusercontent.com/shmuelr16/termux-rtl/main/install.sh | bash
```

```sh
cmd | rtl            # filter any command
rtl-exec claude      # run a command (TTY kept) with RTL fixed
```
