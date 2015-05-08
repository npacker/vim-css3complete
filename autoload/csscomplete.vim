" Vim completion script
" Based on Mikolaj Machowski's csscomplete.vim
" Based on Chris Yip's experience version
" Based on Christian Angermann's version
"
" Language: CSS 3
" Version: 2.0
" Maintainer: Nigel Packer
" Last Change: 5 May 2015
"

function! csscomplete#backgroundPosition()
  let result = []

  let vertical   = split('top center bottom')
  let horizontal = split('left center right')
  let vals = matchstr(s:line, '.*:\s*\zs.*')

  if vals =~ '^\%([a-zA-Z]\+\)\?$'
    result = horizontal
  elseif vals =~ '^[a-zA-Z]\+\s\+\%([a-zA-Z]\+\)\?$'
    result = vertical
  endif

  return result
endfunction

function! csscomplete#getMultiProperties(color, style, width)
  let result = []

  let vals = matchst(s:line, '.*:\s*\zs.*')

  if vals =~ '^\%([a-zA-Z0-9.]\+\)\?$'
    result = split(a:width)
  elseif vals =~ '^[a-zA-Z0-9.]\+\s\+\%([a-zA-Z]\+\)\?$'
    result = split(a:style)
  elseif vals =~ '^[a-zA-Z0-9.]\+\s\+[a-zA-Z]\+\s\+\%([a-zA-Z(]\+\)\?$'
    result = a:color_values
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

function! csscomplete#buildPropertySuffixes(property_name, suffixes, ...)
  let list = [a:property_name]

  for suffix in a:suffixes
    let list += [a:property_name.'-'.suffix]
  endfor

  return join(list)
endfunction

function! csscomplete#getPropertiesValues()
  let props = {}

  let common_values = {
    \'timing-function': split('ease ease-in ease-out ease-in-out linear cubic-bezier( step-start step-stop steps('),
    \'color':           split('transparent # rgb( rgba( hsl('),
    \'url':             split('url( none'),
    \'line-style':      split('none hidden dotted dashed solid double groove ridge inset outset'),
    \'line-width':      split('thin thick medium')
  \}

  let props.animation = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes('animation', split('delay direction duration fill-mode iteration-count name play-state timing-function')),
    \'VALUES': {
      \'animation-direction':       split('alternate alternate-reverse normal reverse'),
      \'animation-iteration-count': split('infinite'),
      \'animation-name':            split('none'),
      \'animation-timing-function': common_values['timing-function']
    \}
  \}

  let props.animation.VALUES.animation = csscomplete#collectPropertyValues(props.animation)

  let props.align = {
    \'KEYWORDS': 'align-items align-self',
    \'VALUES': {
       \'align-items': split('flex-start flex-end center baseline strech')
    \}
  \}

  let props.align.VALUES['align-self'] = ['auto'] + props.align.VALUES['align-items']

  let props.transition = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes('transition', split('delay duration property timing-function')),
    \'VALUES': {
      \'transition-property':        split('all none color background-color'),
      \'transition-timing-function': common_values['timing-function']
    \}
  \}

  let props.transition.VALUES.transition = csscomplete#collectPropertyValues(props.transition)

  let props.color = {
    \'KEYWORDS': 'color',
    \'VALUES': common_values['color']
  \}

  let props.background = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes('background', split('attachment clip color image origin position repeat size')),
    \'VALUES': {
      \'background-attachment': split('scroll fixed'),
      \'background-clip':       split('border-box content-box padding-box inherit'),
      \'background-color':      common_values['color'],
      \'background-image':      common_values['url'],
      \'background-origin':     split('border-box content-box padding-box inherit'),
      \'background-repeat':     split('repeat repeat-x repeat-y no-repeat'),
      \'background-size':       split('auto cover contain'),
      \'background-position':   csscomplete#backgroundPosition()
    \}
  \}

  let props.background.VALUES.background = csscomplete#collectPropertyValues(props.background)
  let props.column = {
    \'KEYWORDS': 'columns column-count column-fill column-gap column-span column-with',
    \'VALUES': {
    \}
  \}

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

  let props.font = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes('font', split('face family size size-adjust stretch style variant weight')),
    \'VALUES': {
      \'font-family':  split('sans-serif serif monospace cursive fantasy'),
      \'font-size':    split('xx-small x-small small medium large x-large xx-large larger smaller'),
      \'font-style':   split('normal italic oblique'),
      \'font-variant': split('normal small-caps'),
      \'font-weight':  split('normal bold bolder lighter 100 200 300 400 500 600 700 800 900')
    \}
  \}
  let props.font.VALUES.font = csscomplete#collectPropertyValues(props.font)

  let props.text = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes('text', split('align decoration indent overflow rendering shadow transform'), 1),
    \'VALUES': {
      \'text-align':      split('left right center justify'),
      \'text-decoration': split('none underline overline line-through blink'),
      \'text-shadow':     common_values['color'],
      \'text-transform':  split('capitalize uppercase lowercase none')
    \}
  \}

  let prop_name = 'list-style'
  let props[prop_name] = {
    \'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('image position type'), 1),
    \'VALUES': {
      \'list-style-image':    common_values['url'],
      \'list-style-position': split('inside outside'),
      \'list-style-type':     split('disc circle square decimal decimal-leading-zero lower-roman upper-roman lower-latin upper-latin none')
    \}
  \}
  let props[prop_name].VALUES[prop_name] = csscomplete#collectPropertyValues(props[prop_name])

  let borders = csscomplete#buildPropertySuffixes('border', split('bottom collapse color left radius right bottom-left-radius bottom-right-radius top top-left-radius top-right-radius spacing style width'))
  let borders .= ' ' . csscomplete#buildPropertySuffixes('border-bottom', split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes('border-left',   split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes('border-right',  split('color style width'), 1)
  let borders .= ' ' . csscomplete#buildPropertySuffixes('border-top',    split('color style width'), 1)

  let props.border = { 'KEYWORDS': borders, 'VALUES': {} }

  for key in split(props.border.KEYWORDS)
    if key =~ '-color$'
      let props.border.VALUES[key] = common_values['color']
    elseif key =~ '-style$'
      let props.border.VALUES[key] = common_values['line-style']
    elseif key =~ '-width$'
      let props.border.VALUES[key] = common_values['line-width']
    else
      let props.border.VALUES[key] = common_values['color'] + common_values['line-style'] + common_values['line-width']
    endif
  endfor

  let prop_name = 'margin'
  let props[prop_name] = { 'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('top right bottom left')) }

  let prop_name = 'padding'
  let props[prop_name] = { 'KEYWORDS': csscomplete#buildPropertySuffixes(prop_name, split('top right bottom left')) }

  let boxes = 'box-shadow box-sizing'

  let props.KEYWORDS = split('align-items '
    \.  props.animation.KEYWORDS.' azimuth backface-visibility '
    \.  props.background.KEYWORDS.' '.props.border.KEYWORDS
    \.' bottom '.boxes.' caption-side clear clip clip-path '
    \.  props.color.KEYWORDS.' '
    \.  props.column.KEYWORDS.' '.props['column-rule'].KEYWORDS
    \.' content counter-increment counter-reset cue cue-after cue-before cursor direction display elevation empty-cells filter float '
    \.  props.font.KEYWORDS.' height image-rendering '
    \.' ime-mode left letter-spacing line-height '
    \.  props['list-style'].KEYWORDS.' '
    \.  props.margin.KEYWORDS
    \.' marker-offset marks mask max-height max-width min-height min-width opacity orient orphans '
    \.  props.outline.KEYWORDS.' overflow overflow-x overflow-y '
    \.  props.padding.KEYWORDS
    \.' page-break-after page-break-before page-break-inside pause pause-after pause-before '
    \.' pitch pitch-range play-during pointer-events position quotes resize right richness '
    \.' speak speak-header speak-numeral speak-punctuation speech-rate stress table-layout '
    \.  props.text.KEYWORDS.' top transform transform-origin '
    \.  props.transition.KEYWORDS.' unicode-bidi vertical-align visibility voice-family volume white-space widows width word-spacing word-wrap z-index'
  \)

  return props
endfunction

function! csscomplete#CompleteCSS(findstart, base)
  let s:line = getline('.')

  if a:findstart
    " We need whole line to proper checking
    let start = col('.') - 1
    let compl_begin = col('.') - 2

    while start >= 0 && s:line[start - 1] =~ '\%(\k\|-\)'
      let start -= 1
    endwhile

    let b:compl_context = s:line[0:compl_begin]

    return start
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
  if exists("b:compl_context")
    let s:line = b:compl_context
    unlet! b:compl_context
  else
    let s:line = a:base
  endif

  let line = s:line
  let res = []
  let res2 = []
  let borders = {}

  let propertiesValues = csscomplete#getPropertiesValues()
  let KEYWORDS = propertiesValues.KEYWORDS

  " Check last occurrence of sequence
  let openbrace =  strridx(line, '{')
  let closebrace = strridx(line, '}')
  let colon =      strridx(line, ':')
  let semicolon =  strridx(line, ';')
  let opencomm =   strridx(line, '/*')
  let closecomm =  strridx(line, '*/')
  let style =      strridx(line, 'style\s*=')
  let atrule =     strridx(line, '@')
  let exclam =     strridx(line, '!')

  if openbrace > -1
    let borders[openbrace] = "openbrace"
  endif

  if closebrace > -1
    let borders[closebrace] = "closebrace"
  endif

  if colon > -1
    let borders[colon] = "colon"
  endif

  if semicolon > -1
    let borders[semicolon] = "semicolon"
  endif

  if opencomm > -1
    let borders[opencomm] = "opencomm"
  endif

  if closecomm > -1
    let borders[closecomm] = "closecomm"
  endif

  if style > -1
    let borders[style] = "style"
  endif

  if atrule > -1
    let borders[atrule] = "atrule"
  endif

  if exclam > -1
    let borders[exclam] = "exclam"
  endif

  if len(borders) == 0 || borders[max(keys(borders))] =~ '^\%(openbrace\|semicolon\|opencomm\|closecomm\|style\)$'
    let entered_property = matchstr(line, '.\{-}\zs[a-zA-Z-]*$')

    for m in KEYWORDS
      if m =~? '^'.entered_property
        call add(res, m . ': ')
      elseif m =~? entered_property
        call add(res2, m . ': ')
      endif
    endfor

    return res + res2
  elseif borders[max(keys(borders))] == 'colon'
    " Get name of property
    let prop = tolower(matchstr(line, '\zs[a-zA-Z-]*\ze\s*:[^:]\{-}$'))
    let is_a_multiple_property = '^\%('. join(keys(propertiesValues), '\|') .'\)'

    if     prop == 'azimuth'
      let values = split('left-side far-left left center-left center center-right right far-right right-side behind leftwards rightwards')

    elseif prop == 'backface-visibility'
      let values = split('hidden visible')

    elseif prop =~ is_a_multiple_property
      let values = propertiesValues[(split(prop, '-')[0])].VALUES[prop]

    elseif prop == 'bottom'
      let values = ['auto']

    elseif prop == 'caption-side'
      let values = split('top bottom')

    elseif prop == 'clear'
      let values = split('none left right both')

    elseif prop == 'clip'
      let values = split('auto, rect(')

    elseif prop == 'clip-path'
      let values = ['none']

    elseif prop == 'color'
      let values = propertiesValues.color.VALUES

    elseif prop == 'content'
      let values = split('normal attr( open-quote close-quote no-open-quote no-close-quote')

    elseif prop =~ 'counter-\%(increment\|reset\)$'
      let values = ['none']

    elseif prop =~ '^\%(cue-after\|cue-before\|cue\)$'
      let values = split('url( none')

    elseif prop == 'cursor'
      let values = split('url( auto crosshair default pointer move e-resize ne-resize nw-resize n-resize se-resize sw-resize s-resize w-resize text wait help progress')

    elseif prop == 'direction'
      let values = split('inherit ltr rtl')

    elseif prop == 'display'
      let values = split('inline block list-item run-in inline-block table inline-table table-row-group table-header-group table-footer-group table-row table-column-group table-column table-cell table-caption none')

    elseif prop == 'elevation'
      let values = split('below level above higher lower')

    elseif prop == 'empty-cells'
      let values = split('show hide')

    elseif prop == 'filter'
      let values = split('url( blur(')

    elseif prop == 'float'
      let values = split('left right none')

    elseif prop =~ '^\%(height\|width\)$'
      let values = ['auto']

    elseif prop =~ '^\%(left\|rigth\)$'
      let values = ['auto']

    elseif prop == 'letter-spacing'
      let values = ['normal']

    elseif prop == 'line-height'
      let values = ['normal']

    elseif prop =~ '^\%(margin\|margin-\%(right\|left\|top\|bottom\)\)$'
      let values = ['auto']

    elseif prop == '^\%(max\|min\)-\%(height\|width\)$'
      let values = ['none']

    elseif prop == 'overflow'
      let values = split(visible hidden scroll auto)

    elseif prop =~ 'page-break-\%(after\|before\)$'
      let values = splitl('auto always avoid left right')

    elseif prop == 'page-break-inside'
      let values = split('auto avoid')

    elseif prop == 'pitch'
      let values = split('x-low low medium high x-high')

    elseif prop == 'play-during'
      let values = split('url( mix repeat auto none')

    elseif prop == 'position'
      let values = split('static relative absolute fixed')

    elseif prop == 'quotes'
      let values = ['none']

    elseif prop == 'speak-header'
      let values = split('once always')

    elseif prop == 'speak-numeral'
      let values = split('digits continuous')

    elseif prop == 'speak-punctuation'
      let values = split('code none')

    elseif prop == 'speak'
      let values = split(normal none spell-out)

    elseif prop == 'speech-rate'
      let values = split('x-slow slow medium fast x-fast faster slower')

    elseif prop == 'table-layout'
      let values = split('auto fixed')

    elseif prop == 'top'
      let values = ['auto']

    elseif prop == 'unicode-bidi'
      let values = split('normal embed isolate bidi-override isolate-override plaintext')

    elseif prop == 'vertical-align'
      let values = split('baseline sub super top text-top middle bottom text-bottom')

    elseif prop == 'visibility'
      let values = split('visible hidden collapse')

    elseif prop == 'volume'
      let values = split('silent x-soft soft medium loud x-loud')

    elseif prop == 'white-space'
      let values = split('normal pre nowrap pre-wrap pre-line')

    elseif prop == 'word-spacing'
      let values = ['normal']

    elseif prop == 'word-wrap'
      let values = split('normal break-word')

    elseif prop == 'z-index'
      let values = ['auto']

    else
      " If no property match it is possible we are outside of {} and
      " trying to complete pseudo-(class|element)
      let element = tolower(matchstr(line, '\zs[a-zA-Z1-6]*\ze:\{1,2\}[^:[:space:]]\{-}$'))
      let tag_names = ',a,abbr,acronym,address,applet,area,article,aside,audio,b,base,basefont,bdo,big,blockquote,body,br,button,canvas,caption,center,cite,code,col,colgroup,command,datalist,dd,del,details,dfn,dir,div,dl,dt,em,embed,fieldset,font,form,figcaption,figure,footer,frame,frameset,h1,h2,h3,h4,h5,h6,head,header,hgroup,hr,html,img,i,iframe,img,input,ins,isindex,kbd,keygen,label,legend,li,link,map,mark,menu,meta,meter,nav,noframes,noscript,object,ol,optgroup,option,output,p,param,pre,progress,q,rp,rt,ruby,s,samp,script,section,select,small,span,strike,strong,style,sub,summary,sup,table,tbody,td,textarea,tfoot,th,thead,time,title,tr,tt,ul,u,var,variant,video,xmp,'

      if stridx(tag_names, ','.element.',') > -1
        let pseudo_classes = 'active checked default disabled empty enbaled first-child first-of-type focus fullscreen hover indeterminate invalid in-rang lang last-child last-of-type link not nth-child nth-last-child nth-of-type nth-last-of-type only-child only-of-type optional out-of-rang read-only read-write required root target valid visited'
        let pseudo_elements = 'after before choices first-letter first-line repeat-item repeat-index selection value'
        let values = split(pseudo_classes . ' ' . pseudo_elements)
      else
        return []
      endif
    endif
    " Complete values
    let entered_value = matchstr(line, '.\{-}\zs[a-zA-Z0-9#,.(_-]*$')

    for m in values
      if m =~? '^'.entered_value
        call add(res, m)
      elseif m =~? entered_value
        call add(res2, m)
      endif
    endfor

    return res + res2
  elseif borders[max(keys(borders))] == 'closebrace'
    return []
  elseif borders[max(keys(borders))] == 'exclam'
    let entered_imp = matchstr(line, '.\{-}!\s*\zs[a-zA-Z ]*$')
    let values = ['important']

    for m in values
      if m =~? '^'.entered_imp
        call add(res, m)
      endif
    endfor

    return res
  elseif borders[max(keys(borders))] == 'atrule'
    let afterat = matchstr(line, '.*@\zs.*')

    if afterat =~ '\s'
      let atrulename = matchstr(line, '.*@\zs[a-zA-Z-]\+\ze')

      if atrulename == 'media'
        let values = split('screen tty tv projection handheld print braille aural all')
        let entered_atruleafter = matchstr(line, '.*@media\s\+\zs.*$')
      elseif atrulename == 'import'
        let entered_atruleafter = matchstr(line, '.*@import\s\+\zs.*$')

        if entered_atruleafter =~ "^[\"']"
          let filestart = matchstr(entered_atruleafter, '^.\zs.*')
          let files = split(glob(filestart.'*'), '\n')
          let values = map(copy(files), '"\"".v:val')
        elseif entered_atruleafter =~ "^url("
          let filestart = matchstr(entered_atruleafter, "^url([\"']\\?\\zs.*")
          let files = split(glob(filestart.'*'), '\n')
          let values = map(copy(files), '"url(".v:val')
        else
          let values = ['"', 'url(']
        endif
      else
        return []
      endif

      for m in values
        if m =~? '^'.entered_atruleafter
          call add(res, m)
        elseif m =~? entered_atruleafter
          call add(res2, m)
        endif
      endfor

      return res + res2
    endif

    let values = slit('charset page media import font-face')
    let entered_atrule = matchstr(line, '.*@\zs[a-zA-Z-]*$')

    for m in values
      if m =~? '^'.entered_atrule
        call add(res, m .' ')
      elseif m =~? entered_atrule
        call add(res2, m .' ')
      endif
    endfor

    return res + res2
  endif

  return []
endfunction
