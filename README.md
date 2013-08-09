## Gloss
### Glossary term coffeescript library

Gloss takes a json object of glossary terms with definitions, finds uses of each
word in a defined HTML element and adds a definition popover.

Call Gloss on page load with gloss(config). The config object is json, an
example is given below.

    config = {
      element_to_glossify: '#main_content',
      json_path: '/glossaries.json',
      term_field_name: 'name',
      definition_field_name: 'description'
      }

## Requires
*Jquery - for selecting elements
* Twitter bootstrap - for popover function

## License
[LGPL](http://www.gnu.org/licenses/lgpl.html)


