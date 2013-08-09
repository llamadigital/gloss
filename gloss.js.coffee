# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

gloss = (config={}) ->

  # set config defaults
  element_to_glossify = config.element_to_glossify || '#main_content'
  json_path = config.json_path || '/glossary.json' 
  term_field_name = config.term_field_name || 'term'
  definition_field_name = config.definition_field_name || 'definition'
  pjax_on = config.pjax_on || false 
  glossified_term_class = config.glossified_term_class || 'glossary-term'

  if $(element_to_glossify).length
    $.get json_path, (glossary) ->
      word_list = []
      for word in glossary
        do (word) ->
          if is_in_main_content(word)
            word_list.push word
      $(element_to_glossify).find('p').each (index, child) =>
        for word in word_list
          filter_words(child, word)
      $('a[data-toggle=popover]').popover({trigger: 'hover'}).click (e) ->
        e.preventDefault()

  filter_words = (child, word) ->
    if child.nodeType == 1
      for node in child.childNodes
        do (node) ->
          if false == $(node).is('a')
            filter_words(node, word)
    else if (child.nodeType == 3) && (child.data)
      parent = child.parentNode
      regex = new RegExp('\\b' + escape_regexp(word[term_field_name]) + '\\b', 'i')
      match = child.nodeValue.match(regex)
      if match
        matchPos = match.index
        start = child.nodeValue.slice(0, matchPos)
        end = child.nodeValue.slice(matchPos + word[term_field_name].length)
        result = document.createDocumentFragment()
        result.appendChild(document.createTextNode(start))
        result.appendChild(abbr_tag word, match[0])
        result.appendChild(document.createTextNode(end))
        parent.insertBefore(result, child)
        parent.removeChild(child)
        filter_words(parent, word)

  abbr_tag = (term, matched_word) ->
    $('<a href="" data-toggle="popover"></a>').attr('title', term[term_field_name])
      .attr('data-content', term[definition_field_name])
      .addClass(glossified_term_class).html(matched_word)[0]

  escape_regexp = (str) ->
    str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

  is_in_main_content = (word) ->
    regex = new RegExp('\\b' + escape_regexp(word[term_field_name]) + '\\b', 'i')
    return $(element_to_glossify).text().match(regex)

  if pjax_on
    $(document).on('pjax:end', ->
      gloss(config))
      
$ -> 
  gloss(config)
