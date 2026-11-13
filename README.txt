# Kiswa Beauty Parlor — Secure Store Starter

یہ ایک ابتدائی source package ہے، live/deployed website نہیں۔ اس میں:
- Urdu RTL storefront، PKR قیمتیں، sample products/services
- Supabase email/password sign-in والا owner panel
- Products add/delete، orders list
- Database Row Level Security (RLS) policies

## ضروری سیکیورٹی نوٹ
صرف HTML فائل یا browser localStorage سے محفوظ admin system نہیں بنتا۔ یہ starter Supabase Auth + Postgres RLS استعمال کرنے کے لیے ہے۔ اسے live کرنے سے پہلے نیچے کے مراحل مکمل کرنا ضروری ہیں۔

## سیٹ اپ
1. Supabase پر نیا project بنائیں۔
2. Authentication > Users میں مالک کا account بنائیں۔ مالک کا ای میل آپ بعد میں لے سکتے ہیں؛ پاس ورڈ مالک خود بنائے۔
3. مالک کے user UUID کو copy کریں۔
4. `schema.sql` میں ہر `OWNER_USER_UUID` کو اصل UUID سے بدلیں، پھر SQL Editor میں چلائیں۔
5. Project Settings > API سے Project URL اور anon/public key لیں۔ `index.html` میں `YOUR_SUPABASE_PROJECT_URL` اور `YOUR_SUPABASE_ANON_KEY` بدلیں۔
6. `index.html` اور اس package کے assets کسی static host پر publish کریں (مثلاً Cloudflare Pages یا GitHub Pages)۔
7. Supabase Auth میں اپنی published site کا URL Site URL اور Redirect URL میں شامل کریں۔
8. ایک test customer order اور ایک owner login سے permissions چیک کریں۔

## مالک کی رسائی
- مالک کا اکاؤنٹ صرف Auth dashboard سے بنایا جائے۔
- پاس ورڈ مالک خود رکھے؛ کسی کو chat میں پاس ورڈ نہ بھیجیں۔
- صرف مالک UUID کو SQL policy میں allow کیا گیا ہے۔
- `service_role` key کبھی `index.html` یا کسی browser code میں نہ ڈالیں۔
- مالک کے علاوہ کوئی user نہ بنائیں۔ اگر public signups کی ضرورت نہیں تو Supabase Auth settings میں نئے signups بند کریں۔

## موجودہ حدود
- یہ starter checkout/payment gateway نہیں جوڑتا؛ آرڈر درخواست جمع ہوتی ہے۔
- WhatsApp نمبر شامل نہیں، اس لیے WhatsApp handoff فعال نہیں۔
- اس ابتدائی ورژن میں services ابھی نمونہ جاتی متن ہیں؛ service management admin UI شامل نہیں۔
- product image URL درج کیا جا سکتا ہے؛ محفوظ image upload/storage policy الگ سے configure کرنا ہوگا۔
- live domain/hosting account کی configuration آپ کے اپنے اختیار اور منظوری سے ہوگی۔
