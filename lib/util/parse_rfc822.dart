const MONTHS = {
  'Jan': '01',
  'Feb': '02',
  'Mar': '03',
  'Apr': '04',
  'May': '05',
  'Jun': '06',
  'Jul': '07',
  'Aug': '08',
  'Sep': '09',
  'Oct': '10',
  'Nov': '11',
  'Dec': '12',
};

DateTime? parseRfc822(String input) {
  var splits = input.split(' ');
  var reformatted = splits[3] +
      '-' +
      MONTHS[splits[2]]! +
      '-' +
      (splits[1].length == 1 ? '0' + splits[1] : splits[1]) +
      ' ' +
      splits[4] +
      ' ' +
      '+0000';
  return DateTime.tryParse(reformatted);
}