Handlebars.registerHelper('text', function(obj) {
  try {
    return obj['#text'];
  } catch (err) {
    return '';
  }
});

Handlebars.registerHelper('image_url', function(obj) {
  try {
    return obj[0]['#text'];
  } catch (err) {
    return '';
  }
});

Handlebars.registerHelper('avatar_url', function(obj) {
  try {
    return obj[1]['#text'];
  } catch (err) {
    return '';
  }
});