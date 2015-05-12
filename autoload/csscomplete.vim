" Vim completion script
" Based on Mikolaj Machowski's csscomplete.vim
" Based on Chris Yip's experience version
" Based on Christian Angermann's version
"
" Language: CSS 3
" Version: 2.0
" Maintainer: Nigel Packer
" Last Change: 12 May 2015
"

" Constants
let s:SYMBOLS = {
  \'OPEN_BRACE': '{',
  \'CLOSE_BRACE': '}',
  \'OPEN_COMMENT': '/*',
  \'CLOSE_COMMENT': '*/',
  \'COLON': ':',
  \'SEMI_COLON': ';',
  \'AMPERSAND': '@',
  \'BANG': '!',
  \'STYLE': 'style\s*=',
\}

" HTML tags
let s:TAGS = [
  \'a',
  \'abbr',
  \'acronym',
  \'address',
  \'applet',
  \'area',
  \'article',
  \'aside',
  \'audio',
  \'b',
  \'base',
  \'basefont',
  \'bdo',
  \'big',
  \'blockquote',
  \'body',
  \'br',
  \'button',
  \'canvas',
  \'caption',
  \'center',
  \'cite',
  \'code',
  \'col',
  \'colgroup',
  \'command',
  \'datalist',
  \'dd',
  \'del',
  \'details',
  \'dfn',
  \'dir',
  \'div',
  \'dl',
  \'dt',
  \'em',
  \'embed',
  \'fieldset',
  \'font',
  \'form',
  \'figcaption',
  \'figure',
  \'footer',
  \'frame',
  \'frameset',
  \'h1',
  \'h2',
  \'h3',
  \'h4',
  \'h5',
  \'h6',
  \'head',
  \'header',
  \'hgroup',
  \'hr',
  \'html',
  \'img',
  \'i',
  \'iframe',
  \'img',
  \'input',
  \'ins',
  \'isindex',
  \'kbd',
  \'keygen',
  \'label',
  \'legend',
  \'li',
  \'link',
  \'map',
  \'mark',
  \'menu',
  \'meta',
  \'meter',
  \'nav',
  \'noframes',
  \'noscript',
  \'object',
  \'ol',
  \'optgroup',
  \'option',
  \'output',
  \'p',
  \'param',
  \'pre',
  \'progress',
  \'q',
  \'rp',
  \'rt',
  \'ruby',
  \'s',
  \'samp',
  \'script',
  \'section',
  \'select',
  \'small',
  \'span',
  \'strike',
  \'strong',
  \'style',
  \'sub',
  \'summary',
  \'sup',
  \'table',
  \'tbody',
  \'td',
  \'textarea',
  \'tfoot',
  \'th',
  \'thead',
  \'time',
  \'title',
  \'tr',
  \'tt',
  \'ul',
  \'u',
  \'var',
  \'variant',
  \'video',
  \'xmp',
\]

" CSS pseudo-classes
let s:PSEUDO_CLASSES = [
  \'active',
  \'checked',
  \'default',
  \'disabled',
  \'empty',
  \'enbaled',
  \'first-child',
  \'first-of-type',
  \'focus',
  \'fullscreen',
  \'hover',
  \'indeterminate',
  \'invalid',
  \'in-rang',
  \'lang',
  \'last-child',
  \'last-of-type',
  \'link',
  \'not',
  \'nth-child',
  \'nth-last-child',
  \'nth-of-type',
  \'nth-last-of-type',
  \'only-child',
  \'only-of-type',
  \'optional',
  \'out-of-rang',
  \'read-only',
  \'read-write',
  \'required',
  \'root',
  \'target',
  \'valid',
  \'visited',
\]

" CSS pseudo-elements
let s:PSEUDO_ELEMENTS = [
  \'after',
  \'before',
  \'choices',
  \'first-letter',
  \'first-line',
  \'repeat-item',
  \'repeat-index',
  \'selection',
  \'value',
\]

function! csscomplete#backgroundPosition()
  let result = []

  let vertical   = split('top center bottom')
  let horizontal = split('left center right')
  let vals       = matchstr(s:line, '.*:\s*\zs.*')

  if vals =~ '^\%([a-zA-Z]\+\)\?$'
    let result = horizontal
  elseif vals =~ '^[a-zA-Z]\+\s\+\%([a-zA-Z]\+\)\?$'
    let result = vertical
  else
    let result = horizontal + vertical
  endif

  return result
endfunction

function! csscomplete#collectPropertyValues(property)
  let result = []
  let values = a:property.VALUES

  for key in keys(values)
    let result += values[key]
  endfor

  return result
endfunction

function! csscomplete#getPropertyPrefix(property_name)
  return get(split(a:property_name, '-'), 0)
endfunction

function! csscomplete#buildPropertySuffixes(property_name, suffixes, ...)
  let list = [a:property_name]

  for suffix in a:suffixes
    let list += [a:property_name . '-' . suffix]
  endfor

  return join(list)
endfunction

function! csscomplete#buildPropertiesValues()
  let props = {}

  let common_values = {
    \'color':           split('transparent # rgb( rgba( hsl('),
    \'line-style':      split('none hidden dotted dashed solid double groove ridge inset outset'),
    \'line-width':      split('thin thick medium'),
    \'timing-function': split('ease ease-in ease-out ease-in-out linear cubic-bezier( step-start step-stop steps('),
    \'url':             split('url( none'),
  \}

  " ANIMATION
  let prop_name = 'animation'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('delay direction duration fill-mode iteration-count name play-state timing-function')),
    \'VALUES': {
      \prop_name.'-direction':       split('alternate alternate-reverse normal reverse'),
      \prop_name.'-iteration-count': split('infinite'),
      \prop_name.'-name':            split('none'),
      \prop_name.'-timing-function': common_values['timing-function']
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " ALIGN
  let prop_name = 'align'
  let props[prop_name] = {
    \'KEYWORDS': 'align-items align-self',
    \'VALUES': {
       \prop_name.'-items': split('flex-start flex-end center baseline strech')
    \}
  \}
  let props[prop_name].VALUES['align-self'] = ['auto'] + props[prop_name].VALUES['align-items']

  " TRANSITION
  let prop_name = 'transition'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('delay duration property timing-function')),
    \'VALUES': {
      \prop_name.'-property':        split('all none color background-color'),
      \prop_name.'-timing-function': common_values['timing-function']
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " COLOR
  let prop_name = 'color'
  let props[prop_name] = {
    \'KEYWORDS': 'color',
    \'VALUES':   common_values[prop_name]
  \}

  " BACKGROUND
  let prop_name = 'background'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('attachment clip color image origin position repeat size')),
    \'VALUES': {
      \prop_name.'-attachment': split('scroll fixed'),
      \prop_name.'-clip':       split('border-box content-box padding-box inherit'),
      \prop_name.'-color':      common_values['color'],
      \prop_name.'-image':      common_values['url'],
      \prop_name.'-origin':     split('border-box content-box padding-box inherit'),
      \prop_name.'-repeat':     split('repeat repeat-x repeat-y no-repeat'),
      \prop_name.'-size':       split('auto cover contain'),
      \prop_name.'-position':   csscomplete#backgroundPosition()
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " COLUMN
  let props.column = {
    \'KEYWORDS': 'columns column-count column-fill column-gap column-span column-with',
    \'VALUES': {
    \}
  \}

  " COLUMN-RULE
  let prop_name = 'column-rule'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('color style width')),
    \'VALUES': {
      \prop_name.'-color': common_values['color'],
      \prop_name.'-style': common_values['line-style'],
      \prop_name.'-width': common_values['line-width']
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " OUTLINE
  let prop_name = 'outline'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('color offset style width')),
    \'VALUES': {
      \prop_name.'-color': common_values['color'],
      \prop_name.'-style': common_values['line-style'],
      \prop_name.'-width': common_values['line-width']
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " FONT
  let prop_name = 'font'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('face family size size-adjust stretch style variant weight')),
    \'VALUES': {
      \prop_name.'-family':  split('sans-serif serif monospace cursive fantasy'),
      \prop_name.'-size':    split('xx-small x-small small medium large x-large xx-large larger smaller'),
      \prop_name.'-style':   split('normal italic oblique'),
      \prop_name.'-variant': split('normal small-caps'),
      \prop_name.'-weight':  split('normal bold bolder lighter 100 200 300 400 500 600 700 800 900')
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " TEXT
  let prop_name = 'text'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('align decoration indent overflow rendering shadow transform'), 1),
    \'VALUES': {
      \prop_name.'-align':      split('left right center justify'),
      \prop_name.'-decoration': split('none underline overline line-through blink'),
      \prop_name.'-shadow':     common_values['color'],
      \prop_name.'-transform':  split('capitalize uppercase lowercase none')
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " LIST-STYLE
  let prop_name = 'list-style'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('image position type'), 1),
    \'VALUES': {
      \prop_name.'-image':    common_values['url'],
      \prop_name.'-position': split('inside outside'),
      \prop_name.'-type':     split('disc circle square decimal decimal-leading-zero lower-roman upper-roman lower-latin upper-latin none')
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  " BORDER
  let prop_name = 'border'

  let borders  =       csscomplete#buildPropertySuffixes(prop_name,           split('bottom collapse color left radius right bottom-left-radius bottom-right-radius top top-left-radius top-right-radius spacing style width'))
  let borders .= ' ' . csscomplete#buildPropertySuffixes(prop_name.'-bottom', split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes(prop_name.'-left',   split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes(prop_name.'-right',  split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes(prop_name.'-top',    split('color style width'), 1)

  let props[prop_name] = {
    \'KEYWORDS': borders,
    \'VALUES': {
    \}
  \}

  for key in split(props[prop_name].KEYWORDS)
    if key =~ '-color$'
      let props[prop_name].VALUES[key] = common_values['color']
    elseif key =~ '-style$'
      let props[prop_name].VALUES[key] = common_values['line-style']
    elseif key =~ '-width$'
      let props[prop_name].VALUES[key] = common_values['line-width']
    elseif key =~ '-collapse'
      let props[prop_name].VALUES[key] = split('separate collapse')
    else
      let props[prop_name].VALUES[key] = common_values['color'] + common_values['line-style'] + common_values['line-width'] + split('separate collapse')
    endif
  endfor

  " MARGIN
  let prop_name = 'margin'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('top right bottom left')),
    \'VALUES': {
    \}
  \}

  " PADDING
  let prop_name = 'padding'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('top right bottom left')),
    \'VALUES': {
    \}
  \}

  let props.KEYWORDS = split(
    \'  align-items '
    \.  props.animation.KEYWORDS
    \.' azimuth backface-visibility '
    \.  props.background.KEYWORDS.' '
    \.  props.border.KEYWORDS
    \.' bottom box-shadow box-sizing caption-side clear clip clip-path '
    \.  props.color.KEYWORDS.' '
    \.  props.column.KEYWORDS.' '
    \.  props['column-rule'].KEYWORDS
    \.' content counter-increment counter-reset cue cue-after cue-before cursor direction display elevation empty-cells filter float '
    \.  props.font.KEYWORDS
    \.' height image-rendering ime-mode left letter-spacing line-height '
    \.  props['list-style'].KEYWORDS.' '
    \.  props.margin.KEYWORDS
    \.' marker-offset marks mask max-height max-width min-height min-width opacity orient orphans '
    \.  props.outline.KEYWORDS
    \.' overflow overflow-x overflow-y '
    \.  props.padding.KEYWORDS
    \.' page-break-after page-break-before page-break-inside pause pause-after pause-before pitch pitch-range play-during pointer-events position quotes resize right richness speak speak-header speak-numeral speak-punctuation speech-rate stress table-layout '
    \.  props.text.KEYWORDS
    \.' top transform transform-origin '
    \.  props.transition.KEYWORDS
    \.' unicode-bidi vertical-align visibility voice-family volume white-space widows width word-spacing word-wrap z-index'
  \)

  return props
endfunction

function! csscomplete#buildResult(entered, values)
  let result1 = []
  let result2 = []

  for value in a:values
      if value =~? '^' . a:entered
        call add(result1, value)
      elseif value =~? a:entered
        call add(result2, value)
      endif
  endfor

  return result1 + result2
endfunction

function! csscomplete#findStart()
  let s:line         = getline('.')
  let start          = col('.') - 1
  let complete_begin = col('.') - 2

  while start >= 0 && s:line[start - 1] =~ '\%(\k\|-\)'
    let start -= 1
  endwhile

  let b:context = s:line[0:complete_begin]

  return start
endfunction

function csscomplete#getLastSymbol(line)
  let found      = {}

  let openbrace  = strridx(a:line, s:SYMBOLS.OPEN_BRACE)
  let closebrace = strridx(a:line, s:SYMBOLS.CLOSE_BRACE)
  let colon      = strridx(a:line, s:SYMBOLS.COLON)
  let semicolon  = strridx(a:line, s:SYMBOLS.SEMI_COLON)
  let opencomm   = strridx(a:line, s:SYMBOLS.OPEN_COMMENT)
  let closecomm  = strridx(a:line, s:SYMBOLS.CLOSE_COMMENT)
  let style      = strridx(a:line, s:SYMBOLS.STYLE)
  let ampersand  = strridx(a:line, s:SYMBOLS.AMPERSAND)
  let bang       = strridx(a:line, s:SYMBOLS.BANG)

  if openbrace > -1
    let found[openbrace]  = s:SYMBOLS.OPEN_BRACE
  endif

  if closebrace > -1
    let found[closebrace] = s:SYMBOLS.CLOSE_BRACE
  endif

  if colon > -1
    let found[colon]      = s:SYMBOLS.COLON
  endif

  if semicolon > -1
    let found[semicolon]  = s:SYMBOLS.SEMI_COLON
  endif

  if opencomm > -1
    let found[opencomm]   = s:SYMBOLS.OPEN_COMMNET
  endif

  if closecomm > -1
    let found[closecomm]  = s:SYMBOLS.CLOSE_COMMENT
  endif

  if style > -1
    let found[style]      = s:SYMBOLS.STYLE
  endif

  if ampersand > -1
    let found[ampersand]  = s:SYMBOLS.AMPERSAND
  endif

  if bang > -1
    let found[bang]       = s:SYMBOLS.BANG
  endif

  return get(found, max(keys(found)), '')
endfunction

function! csscomplete#completeProperty(line, properties_values)
  let entered_property = matchstr(a:line, '.\{-}\zs[a-zA-Z-]*$')
  return map(csscomplete#buildResult(entered_property, a:properties_values.KEYWORDS), 'v:val . ": "')
endfunction

function! csscomplete#completeValue(line, properties_values)
  let entered_value     = matchstr(a:line, '.\{-}\zs[a-zA-Z0-9#,.(_-]*$')
  let property          = tolower(matchstr(a:line, '\zs[a-zA-Z-]*\ze\s*:[^:]\{-}$'))
  let is_multi_property = '^\%('. join(keys(a:properties_values), '\|') .'\)'

  if property =~ is_multi_property
    let prefix = csscomplete#getPropertyPrefix(property)
    let values = a:properties_values[prefix].VALUES[property]
  elseif property == 'azimuth'
    let values = split('left-side far-left left center-left center center-right right far-right right-side behind leftwards rightwards')
  elseif property == 'backface-visibility'
    let values = split('hidden visible')
  elseif property == 'bottom'
    let values = ['auto']
  elseif property == 'caption-side'
    let values = split('top bottom')
  elseif property == 'clear'
    let values = split('none left right both')
  elseif property == 'clip'
    let values = split('auto, rect(')
  elseif property == 'clip-path'
    let values = ['none']
  elseif property == 'color'
    let values = a:properties_values.color.VALUES
  elseif property == 'content'
    let values = split('normal attr( open-quote close-quote no-open-quote no-close-quote')
  elseif property =~ 'counter-\%(increment\|reset\)$'
    let values = ['none']
  elseif property =~ '^\%(cue-after\|cue-before\|cue\)$'
    let values = split('url( none')
  elseif property == 'cursor'
    let values = split('url( auto crosshair default pointer move e-resize ne-resize nw-resize n-resize se-resize sw-resize s-resize w-resize text wait help progress')
  elseif property == 'direction'
    let values = split('inherit ltr rtl')
  elseif property == 'display'
    let values = split('inline block list-item run-in inline-block table inline-table table-row-group table-header-group table-footer-group table-row table-column-group table-column table-cell table-caption none')
  elseif property == 'elevation'
    let values = split('below level above higher lower')
  elseif property == 'empty-cells'
    let values = split('show hide')
  elseif property == 'filter'
    let values = split('url( blur(')
  elseif property == 'float'
    let values = split('left right none')
  elseif property =~ '^\%(height\|width\)$'
    let values = ['auto']
  elseif property =~ '^\%(left\|rigth\)$'
    let values = ['auto']
  elseif property == 'letter-spacing'
    let values = ['normal']
  elseif property == 'line-height'
    let values = ['normal']
  elseif property =~ '^\%(margin\|margin-\%(right\|left\|top\|bottom\)\)$'
    let values = ['auto']
  elseif property == '^\%(max\|min\)-\%(height\|width\)$'
    let values = ['none']
  elseif property == 'overflow'
    let values = split('visible hidden scroll auto')
  elseif property =~ 'page-break-\%(after\|before\)$'
    let values = splitl('auto always avoid left right')
  elseif property == 'page-break-inside'
    let values = split('auto avoid')
  elseif property == 'pitch'
    let values = split('x-low low medium high x-high')
  elseif property == 'play-during'
    let values = split('url( mix repeat auto none')
  elseif property == 'position'
    let values = split('static relative absolute fixed')
  elseif property == 'quotes'
    let values = ['none']
  elseif property == 'speak-header'
    let values = split('once always')
  elseif property == 'speak-numeral'
    let values = split('digits continuous')
  elseif property == 'speak-punctuation'
    let values = split('code none')
  elseif property == 'speak'
    let values = split('normal none spell-out')
  elseif property == 'speech-rate'
    let values = split('x-slow slow medium fast x-fast faster slower')
  elseif property == 'table-layout'
    let values = split('auto fixed')
  elseif property == 'top'
    let values = ['auto']
  elseif property == 'unicode-bidi'
    let values = split('normal embed isolate bidi-override isolate-override plaintext')
  elseif property == 'vertical-align'
    let values = split('baseline sub super top text-top middle bottom text-bottom')
  elseif property == 'visibility'
    let values = split('visible hidden collapse')
  elseif property == 'volume'
    let values = split('silent x-soft soft medium loud x-loud')
  elseif property == 'white-space'
    let values = split('normal pre nowrap pre-wrap pre-line')
  elseif property == 'word-spacing'
    let values = ['normal']
  elseif property == 'word-wrap'
    let values = split('normal break-word')
  elseif property == 'z-index'
    let values = ['auto']
  else
    let element = tolower(matchstr(s:line, '\zs[a-zA-Z1-6]*\ze:\{1,2\}[^:[:space:]]\{-}$'))

    if index(s:TAGS, element) > -1
      let values = s:PSEUDO_CLASSES + s:PSEUDO_ELEMENTS
    endif
  endif

  return csscomplete#buildResult(entered_value, values)
endfunction

function! csscomplete#completeBang(line)
  let entered_important = matchstr(a:line, '.\{-}!\s*\zs[a-zA-Z ]*$')
  let values            = ['important']
  return csscomplete#buildResult(entered_important, values)
endfunction

function! csscomplete#completeAtrule(line)
  let result = []
  let after_at = matchstr(a:line, '.*@\zs.*')

  if after_at =~ '\s'
    let atrule_name = matchstr(a:line, '.*@\zs[a-zA-Z-]\+\ze')

    if atrule_name == 'media'
      let atrule_after = matchstr(a:line, '.*@media\s\+\zs.*$')
      let values       = split('screen tty tv projection handheld print braille aural all')
    elseif atrule_name == 'import'
      let atrule_after = matchstr(a:line, '.*@import\s\+\zs.*$')

      if atrule_after =~ "^[\"']"
        let filestart = matchstr(atrule_after, '^.\zs.*')
        let files     = split(glob(filestart.'*'), '\n')
        let values    = map(copy(files), '"\"".v:val')
      elseif atrule_after =~ "^url("
        let filestart = matchstr(atrule_after, "^url([\"']\\?\\zs.*")
        let files     = split(glob(filestart.'*'), '\n')
        let values    = map(copy(files), '"url(".v:val')
      else
        let values = split('" url(')
      endif
    endif

    let result = csscomplete#buildResult(atrule_after, values)
  else
    let values = split('charset page media import font-face')
    let atrule = matchstr(a:line, '.*@\zs[a-zA-Z-]*$')
    " insert space
    let result = csscomplete#buildResult(atrule, values)
  endif

  return result
endfunction

function! csscomplete#CompleteCSS(findstart, base)
  if a:findstart
    return csscomplete#findStart()
  endif

  " There are few chars important for context:
  " ^ ; : { } /* */
  " Where ^ is start of line and /* */ are comment borders
  " Depending on their relative position to cursor we will know what should
  " be completed.
  " 1. if nearest are ^ or { or ; current word is property
  " 2. if : it is value (with exception of pseudo things)
  " 3. if } we are outside of css definitions
  " 4. for comments ignoring is be the easiest but assume they are the same
  "   as 1.
  " 5. if @ complete at-rule
  " 6. if ! complete important
  if exists("b:context")
    let s:line = b:context
    unlet! b:context
  else
    let s:line = a:base
  endif

  let line              = s:line
  let last_symbol       = csscomplete#getLastSymbol(line)
  let properties_values = csscomplete#buildPropertiesValues()
  let result            = []

  if empty(last_symbol) || last_symbol =~ '^\%(' . join([s:SYMBOLS.OPEN_BRACE, s:SYMBOLS.SEMI_COLON, s:SYMBOLS.OPEN_COMMENT, s:SYMBOLS.CLOSE_COMMENT, s:SYMBOLS.STYLE], '\|') . '\)$'
    let result = csscomplete#completeProperty(line, properties_values)
  elseif last_symbol == s:SYMBOLS.COLON
    let result = csscomplete#completeValue(line, properties_values)
  elseif last_symbol == s:SYMBOLS.BANG
    let result = csscomplete#completeBang(line)
  elseif last_symbol == s:SYMBOLS.AMPERSAND
    let result = csscomplete#completeAtrule(line)
  endif

  return result
endfunction
