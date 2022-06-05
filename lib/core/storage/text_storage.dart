class WelcomeTexts {
  static String welcomeText = 'Lorem ipsum dolor sit amet.';
  static String buttonText = 'Başla';
  static String welcome = 'Hosgeldiniz';
}

class ValidateTexts {
  static String emptyName = 'Lütfen isminizi giriniz.';
  static String emptyPhoneNumber = 'Lütfen bir telefon numarası giriniz.';
  static String emptyEmail = 'Lütfen email adresinizi giriniz.';
  static String emptyPassword = 'Lütfen şifrenizi giriniz.';
  static String emptyPasswordControl = 'Lütfen şifrenizi tekrar giriniz.';
  static String passwordNotMatch = 'Şifreler uyuşmuyor.';
  static String emailNotValid = 'Lütfen geçerli bir email adresi giriniz.';
  static String phoneNumberNotValid = 'Lütfen geçerli bir telefon numarası giriniz.';
  static String passwordLenght = 'Şifre en az 8 karakter olmalıdır.';
  static String passwordCharacter = 'Şifrenizde en az bir özel karakter olmalıdır.';
  static String descriptionLength = 'Açıklama en az 50 karakter olmalıdır.';
  static String titleLength = 'Başlık en az 10 karakter olmalıdır.';
  static String addressLenght = "Adres en az 15 karakter olmalıdır.";
  static String emptySalaryField = "Boş bırakılamaz.";
  static String emptyField = "Bu alan boş bırakılamaz.";
}

class AuthStatusTexts {
  static String signIn = 'Giriş Yap';
  static String signUp = 'Kayıt Ol';
  static String hasAccount = 'Zaten bir hesabınız var mı?';
  static String noAccount = 'Hesabınız yok mu?';
  static String goToLogin = 'Giriş Sayfasına Git';
  static String confirm = 'Onayla';
  static String cancel = 'Vazgeç';
  static String forgotPassword = 'Şifremi Unuttum';
  static String successRegister =
      'Hesabınız oluşturuldu. Lütfen mail adresinize gönderilen linke tıklayarak hesabınızı doğrulayınız.';
  static String send = 'Gönder';
  static String createAnAccount = 'Hesap Oluştur';
  static String exit = 'Çıkış Yap';
  static String passwordResetSend =
      'Girmiş olduğunuz mail adresine şifre sıfırlama linki gönderilmiştir.';
}

class HintTexts {
  static String nameHint = 'İsminiz';
  static String phoneNumberHint = 'Telefon No: 5554443322';
  static String emailHint = 'email@adres.com';
  static String passwordHint = 'Şifreniz';
  static String passwordControlHint = 'Şifrenizi tekrar giriniz';
  static String currentPassword = 'Mevcut Şifreniz';
  static String newPassword = 'Yeni Şifreniz';
  static String newEmail = 'Yeni email adresiniz';
  static String currentMail = 'Mevcut email adresiniz';
}

class ErrorTexts {
  static String error = 'Bir hata oluştu.';
  static String emailAlreadyUse = 'Bu email adresi zaten kullanılıyor.';
  static String emailNotValid = 'Lütfen geçerli bir email adresi giriniz.';
  static String passwordLenght = 'Şifre en az 8 karakter olmalıdır.';
  static String nameEmpty = 'İsim boş bırakılamaz.';
  static String userNotFound = 'Girilen parametrelere ait bir kullanıcı bulunamadı.';
  static String wrongPassword = 'Girilen şifre hatalı.';
  static String invalidEmail = 'Lütfen geçerli bir email adresi giriniz.';
  static String weakPassword = 'Şifreniz zayıf';

  // toomanyrequests
  static String tooManyRequests =
      'Çok fazla istek gönderildi. Daha sonra tekrar deneyiniz';

  // invalidverificationcode
  static String invalidVerificationCode = 'Geçersiz doğrulama kodu';

  // invalidverificationid
  static String invalidVerificationId = 'Bu kullanıcının doğrulama id\'si bulunamadı';
  static String tryAgainLater = 'Lütfen daha sonra tekrar deneyiniz.';
  static String errorOnExit = 'Çıkış yapılırken bir hata oluştu.';

  //internal error
  static String internalError = 'Dahili bir hata oluştu.';
  static String networkError = 'Lütfen internet bağlantınızı kontrol ediniz.';
}

class UpdateTexts {
  static String passwordUpdate = 'Şifrenizi değiştirmek için bilgilerinizi giriniz';
  static String emailUpdate = 'Email adresinizi değiştirmek için bilgilerinizi giriniz';
  static String nameUpdate = "İsminizi giriniz";
  static String passwordUpdateSuccess = 'Şifreniz başarıyla değiştirildi.';
  static String emailUpdateSuccess = 'Email adresiniz başarıyla değiştirildi.';
  static String nameUpdateSuccess = 'İsim başarıyla değiştirildi.';
  static String phoneNumberUpdateSuccess = 'Telefon numaranız başarıyla değiştirildi.';
  static String cityUpdateSuccess = 'Şehir Bilgisi başarıyla güncellendi.';
  static String confirmDeleteAccount = 'Hesabınızı silmek istediğinize emin misiniz?';
  static String deleteAccount = 'Hesabınızı silmek için bilgilerinizi giriniz';
  static String deleteAccountSuccess = 'Hesabınız başarıyla silindi.';
  static String deleteAccountError = 'Hesabınızı silerken bir hata oluştu.';
  static String closeNotification = 'Bildirimleri kapat';
  static String yes = 'Evet';
  static String no = 'Hayır';
  static String delete = 'Hesabımı Sil';
}

class DropdownTexts {
  static List<String> cities = [
    "Adana",
    "Adıyaman",
    "Afyonkarahisar",
    "Ağrı",
    "Amasya",
    "Ankara",
    "Antalya",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakir",
    "Edirne",
    "Elazığ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Isparta",
    "Mersin",
    "İstanbul",
    "İzmir",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırklareli",
    "Kırşehir",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Kahramanmaraş",
    "Mardin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Şanlıurfa",
    "Uşak",
    "Van",
    "Yozgat",
    "Zonguldak",
    "Aksaray",
    "Bayburt",
    "Karaman",
    "Kırıkkale",
    "Batman",
    "Şırnak",
    "Bartın",
    "Ardahan",
    "Iğdır",
    "Yalova",
    "Karabük",
    "Kilis",
    "Osmaniye",
    "Düzce"
  ];
  static List<String> categories = [
    'Temizlik',
    'Tadilat',
    'Nakliyat',
    'Tamir',
    "Özel Ders",
    "Sağlık",
    "Düğün",
    "Diğer"
  ];
  static List<String> genders = ['Erkek', 'Kadın', 'Farketmiyor'];
  static List<String> shifts = ['1 Gün', '2-5 Gün', '5-10 Gün', '10-15 Gün'];
}
