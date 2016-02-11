" Vim completion script
" Based on Mikolaj Machowski's csscomplete.vim
" Based on Chris Yip's experience version
" Based on Christian Angermann's version
"
" Language: CSS 3
" Maintainer: Nigel Packer
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

" Values shared my multiple properties
let s:COMMON_VALUES = {
  \'color':           split('transparent # rgb( rgba( hsl('),
  \'line-style':      split('none hidden dotted dashed solid double groove ridge inset outset'),
  \'line-width':      split('thin thick medium'),
  \'timing-function': split('ease ease-in ease-out ease-in-out linear cubic-bezier( step-start step-stop steps('),
  \'url':             split('url( none'),
\}

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

  let values = values(a:property.VALUES)

  for value in values
    let result += value
  endfor

  return result
endfunction

function! csscomplete#getPropertyPrefix(property)
  return get(split(a:property, '-'), 0, a:property)
endfunction

function! csscomplete#buildPropertySuffixes(prefix, suffixes, ...)
  let list = [a:prefix]

  for suffix in a:suffixes
    let list += [a:prefix . '-' . suffix]
  endfor

  return join(list)
endfunction

function! csscomplete#buildPropertiesValues()
  let properties = {}

  " ANIMATION
  let prefix = 'animation'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('delay direction duration fill-mode iteration-count name play-state timing-function')),
    \'VALUES': {
      \prefix.'-direction':       split('alternate alternate-reverse normal reverse'),
      \prefix.'-iteration-count': split('infinite'),
      \prefix.'-name':            split('none'),
      \prefix.'-timing-function': s:COMMON_VALUES['timing-function'],
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " ALIGN
  let prefix = 'align'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('items self')),
    \'VALUES': {
       \prefix.'-items': split('flex-start flex-end center baseline strech'),
    \}
  \}
  let properties[prefix].VALUES['align-self'] = ['auto'] + properties[prefix].VALUES['align-items']

  " TRANSITION
  let prefix = 'transition'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('delay duration prefix timing-function')),
    \'VALUES': {
      \prefix.'-prefix':        split('all none color background-color'),
      \prefix.'-timing-function': s:COMMON_VALUES['timing-function'],
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " BACKGROUND
  let prefix = 'background'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('attachment clip color image origin position repeat size')),
    \'VALUES': {
      \prefix.'-attachment': split('scroll fixed'),
      \prefix.'-clip':       split('border-box content-box padding-box inherit'),
      \prefix.'-color':      s:COMMON_VALUES['color'],
      \prefix.'-image':      s:COMMON_VALUES['url'],
      \prefix.'-origin':     split('border-box content-box padding-box inherit'),
      \prefix.'-position':   csscomplete#backgroundPosition(),
      \prefix.'-repeat':     split('repeat repeat-x repeat-y no-repeat'),
      \prefix.'-size':       split('auto cover contain'),
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " COLUMN
  let prefix = 'column'
  let properties[prefix] = {
    \'PROPERTIES': 'columns ' . csscomplete#buildPropertySuffixes(prefix, split('count fill gap span with')),
    \'VALUES': {}
  \}

  for key in split(properties[prefix].PROPERTIES)
    let properties[prefix].VALUES[key] = []
  endfor

  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " COLUMN-RULE
  let prefix = 'column-rule'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('color style width')),
    \'VALUES': {
      \prefix.'-color': s:COMMON_VALUES['color'],
      \prefix.'-style': s:COMMON_VALUES['line-style'],
      \prefix.'-width': s:COMMON_VALUES['line-width'],
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " OUTLINE
  let prefix = 'outline'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('color offset style width')),
    \'VALUES': {
      \prefix.'-color': s:COMMON_VALUES['color'],
      \prefix.'-style': s:COMMON_VALUES['line-style'],
      \prefix.'-width': s:COMMON_VALUES['line-width'],
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " FONT
  let prefix = 'font'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('family size size-adjust stretch style variant weight')),
    \'VALUES': {
      \prefix.'-family':  split('sans-serif serif monospace cursive fantasy'),
      \prefix.'-size':    split('xx-small x-small small medium large x-large xx-large larger smaller'),
      \prefix.'-style':   split('normal italic oblique'),
      \prefix.'-variant': split('normal small-caps'),
      \prefix.'-weight':  split('normal bold bolder lighter 100 200 300 400 500 600 700 800 900'),
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " TEXT
  let prefix = 'text'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('align decoration indent overflow rendering shadow transform'), 1),
    \'VALUES': {
      \prefix.'-align':      split('left right center justify'),
      \prefix.'-decoration': split('none underline overline line-through blink'),
      \prefix.'-shadow':     s:COMMON_VALUES['color'],
      \prefix.'-transform':  split('capitalize uppercase lowercase none'),
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " LIST-STYLE
  let prefix = 'list-style'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('image position type'), 1),
    \'VALUES': {
      \prefix.'-image':    s:COMMON_VALUES['url'],
      \prefix.'-position': split('inside outside'),
      \prefix.'-type':     split('disc circle square decimal decimal-leading-zero lower-greek lower-latin lower-roman upper-latin upper-roman cjk-ideographic georgian hebrew hiragana hiragana-iroha katakana katakana-iroha none'),
    \}
  \}
  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])
  let properties['list'].VALUES         = properties[prefix].VALUES

  " BORDER
  let prefix = 'border'

  let borders  = csscomplete#buildPropertySuffixes(prefix,           split('bottom collapse color left radius right spacing style top width'))
  let borders .= ' '
  let borders .= csscomplete#buildPropertySuffixes(prefix.'-bottom', split('color left-radius right-radius style width'), 1)
  let borders .= ' '
  let borders .= csscomplete#buildPropertySuffixes(prefix.'-left',   split('color style width'), 1)
  let borders .= ' '
  let borders .= csscomplete#buildPropertySuffixes(prefix.'-right',  split('color style width'), 1)
  let borders .= ' '
  let borders .= csscomplete#buildPropertySuffixes(prefix.'-top',    split('color left-radius right-radius style width'), 1)

  let properties[prefix] = {
    \'PROPERTIES': borders,
    \'VALUES': {}
  \}

  for key in split(properties[prefix].PROPERTIES)
    if key =~ '-color$'
      let properties[prefix].VALUES[key] = s:COMMON_VALUES['color']
    elseif key =~ '-style$'
      let properties[prefix].VALUES[key] = s:COMMON_VALUES['line-style']
    elseif key =~ '-width$'
      let properties[prefix].VALUES[key] = s:COMMON_VALUES['line-width']
    elseif key =~ '-collapse'
      let properties[prefix].VALUES[key] = split('separate collapse')
    else
      let properties[prefix].VALUES[key] = []
    endif
  endfor

  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " MARGIN
  let prefix = 'margin'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('top right bottom left')),
    \'VALUES': {}
  \}

  for key in split(properties[prefix].PROPERTIES)
    let properties[prefix].VALUES[key] = []
  endfor

  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " PADDING
  let prefix = 'padding'
  let properties[prefix] = {
    \'PROPERTIES': csscomplete#buildPropertySuffixes(prefix, split('top right bottom left')),
    \'VALUES': {}
  \}

  for key in split(properties[prefix].PROPERTIES)
    let properties[prefix].VALUES[key] = []
  endfor

  let properties[prefix].VALUES[prefix] = csscomplete#collectPropertyValues(properties[prefix])

  " Assemble property keywords
  let properties.PROPERTIES = split(
    \ ' align-items '
    \.  properties.animation.PROPERTIES
    \.' azimuth backface-visibility '
    \.  properties.background.PROPERTIES
    \.' '
    \.  properties.border.PROPERTIES
    \.' bottom box-shadow box-sizing caption-side clear clip clip-path color '
    \.  properties.column.PROPERTIES
    \.' '
    \.  properties['column-rule'].PROPERTIES
    \.' content counter-increment counter-reset cue cue-after cue-before cursor direction display elevation empty-cells filter float '
    \.  properties.font.PROPERTIES
    \.' height image-rendering ime-mode left letter-spacing line-height '
    \.  properties['list-style'].PROPERTIES
    \.' '
    \.  properties.margin.PROPERTIES
    \.' marker-offset marks mask max-height max-width min-height min-width opacity orient orphans '
    \.  properties.outline.PROPERTIES
    \.' overflow overflow-x overflow-y '
    \.  properties.padding.PROPERTIES
    \.' page-break-after page-break-before page-break-inside pause pause-after pause-before pitch pitch-range play-during pointer-events position quotes resize right richness speak speak-header speak-numeral speak-punctuation speech-rate stress table-layout '
    \.  properties.text.PROPERTIES
    \.' top transform transform-origin '
    \.  properties.transition.PROPERTIES
    \.' unicode-bidi vertical-align visibility voice-family volume white-space widows width word-spacing word-wrap z-index '
  \)

  return properties
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
  let l:start        = col('.') - 1
  let complete_begin = col('.') - 2

  while l:start >= 0 && s:line[l:start - 1] =~ '\%(\k\|-\)'
    let l:start -= 1
  endwhile

  let b:context = s:line[0:complete_begin]

  return l:start
endfunction

function csscomplete#getLastSymbol()
  let found      = {}

  let openbrace  = strridx(s:line, s:SYMBOLS.OPEN_BRACE)
  let closebrace = strridx(s:line, s:SYMBOLS.CLOSE_BRACE)
  let colon      = strridx(s:line, s:SYMBOLS.COLON)
  let semicolon  = strridx(s:line, s:SYMBOLS.SEMI_COLON)
  let opencomm   = strridx(s:line, s:SYMBOLS.OPEN_COMMENT)
  let closecomm  = strridx(s:line, s:SYMBOLS.CLOSE_COMMENT)
  let style      = strridx(s:line, s:SYMBOLS.STYLE)
  let ampersand  = strridx(s:line, s:SYMBOLS.AMPERSAND)
  let bang       = strridx(s:line, s:SYMBOLS.BANG)

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
    let found[opencomm]   = s:SYMBOLS.OPEN_COMMENT
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

function! csscomplete#completeProperty(properties_values)
  let entered_property = matchstr(s:line, '.\{-}\zs[a-zA-Z-]*$')

  return map(csscomplete#buildResult(entered_property, a:properties_values.PROPERTIES), 'v:val . ": "')
endfunction

function! csscomplete#completeValue(properties_values)
  let values            = []

  let entered_value     = matchstr(s:line, '.\{-}\zs[a-zA-Z0-9#,.(_-]*$')
  let property          = tolower(matchstr(s:line, '\zs[a-zA-Z-]*\ze\s*:[^:]\{-}$'))
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
    let values = s:COMMON_VALUES['color']
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
    let values = split('auto visible hidden scroll')
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

function! csscomplete#completeBang()
  let entered_important = matchstr(s:line, '.\{-}!\s*\zs[a-zA-Z ]*$')
  let values            = ['important']
  return csscomplete#buildResult(entered_important, values)
endfunction

function! csscomplete#completeAtrule()
  let result = []

  let after_at = matchstr(s:line, '.*@\zs.*')

  if after_at =~ '\s'
    let atrule_name = matchstr(s:line, '.*@\zs[a-zA-Z-]\+\ze')

    if atrule_name == 'media'
      let atrule_after = matchstr(s:line, '.*@media\s\+\zs.*$')
      let values       = split('screen tty tv projection handheld print braille aural all')
      let result       = csscomplete#buildResult(atrule_after, values)
    elseif atrule_name == 'import'
      let atrule_after = matchstr(s:line, '.*@import\s\+\zs.*$')

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

      let result = csscomplete#buildResult(atrule_after, values)
    endif
  else
    let values = split('charset page media import font-face')
    let atrule = matchstr(s:line, '.*@\zs[a-zA-Z-]*$')
    let result = csscomplete#buildResult(atrule, values)
  endif

  return result
endfunction

function! csscomplete#CompleteCSS(findstart, base)
  if a:findstart
    return csscomplete#findStart()
  endif

  if exists('b:context')
    let s:line = b:context
    unlet! b:context
  else
    let s:line = a:base
  endif

  let result            = []

  let last_symbol       = csscomplete#getLastSymbol()
  let properties_values = csscomplete#buildPropertiesValues()

  if empty(last_symbol) ||
        \ last_symbol == s:SYMBOLS.OPEN_BRACE ||
        \ last_symbol == s:SYMBOLS.SEMI_COLON ||
        \ last_symbol == s:SYMBOLS.OPEN_COMMENT ||
        \ last_symbol == s:SYMBOLS.STYLE
    let result = csscomplete#completeProperty(properties_values)
  elseif last_symbol == s:SYMBOLS.COLON
    let result = csscomplete#completeValue(properties_values)
  elseif last_symbol == s:SYMBOLS.BANG
    let result = csscomplete#completeBang()
  elseif last_symbol == s:SYMBOLS.AMPERSAND
    let result = csscomplete#completeAtrule()
  endif

  return result
endfunction
