int getLanguageIdByCode(String languageCode) {
  switch (languageCode) {
    case 'en':
      return 1;
    case 'zh':
      return 2;
    default:
      return 0;
  }
}
