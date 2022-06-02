## Based roughly on
## https://github.com/mathjax/MathJax-demos-node/blob/master/direct/tex2svg

import {mathjax} from 'mathjax-full/js/mathjax.js'
import {TeX} from 'mathjax-full/js/input/tex.js'
import {SVG} from 'mathjax-full/js/output/svg.js'
import {liteAdaptor} from 'mathjax-full/js/adaptors/liteAdaptor.js'
import {RegisterHTMLHandler} from 'mathjax-full/js/handlers/html.js'
#import {AssistiveMmlHandler} from 'mathjax-full/js/a11y/assistive-mml.js'

## Package list from
## https://github.com/mathjax/MathJax-src/blob/master/ts/input/tex/AllPackages.ts
## Excluding those irrelevant for SVG output or otherwise unimportant;
## see README.md for justifications.
import 'mathjax-full/js/input/tex/base/BaseConfiguration.js'
#import 'mathjax-full/js/input/tex/action/ActionConfiguration.js'
import 'mathjax-full/js/input/tex/ams/AmsConfiguration.js'
import 'mathjax-full/js/input/tex/amscd/AmsCdConfiguration.js'
#import 'mathjax-full/js/input/tex/bbox/BboxConfiguration.js'
import 'mathjax-full/js/input/tex/boldsymbol/BoldsymbolConfiguration.js'
import 'mathjax-full/js/input/tex/braket/BraketConfiguration.js'
import 'mathjax-full/js/input/tex/bussproofs/BussproofsConfiguration.js'
import 'mathjax-full/js/input/tex/cancel/CancelConfiguration.js'
#import 'mathjax-full/js/input/tex/cases/CasesConfiguration.js'
import 'mathjax-full/js/input/tex/centernot/CenternotConfiguration.js'
import 'mathjax-full/js/input/tex/color/ColorConfiguration.js'
#import 'mathjax-full/js/input/tex/colorv2/ColorV2Configuration.js'
import 'mathjax-full/js/input/tex/colortbl/ColortblConfiguration.js'
#import 'mathjax-full/js/input/tex/configmacros/ConfigMacrosConfiguration.js'
#import 'mathjax-full/js/input/tex/empheq/EmpheqConfiguration.js'
#import 'mathjax-full/js/input/tex/enclose/EncloseConfiguration.js'
#import 'mathjax-full/js/input/tex/extpfeil/ExtpfeilConfiguration.js'
import 'mathjax-full/js/input/tex/gensymb/GensymbConfiguration.js'
#import 'mathjax-full/js/input/tex/html/HtmlConfiguration.js'
import 'mathjax-full/js/input/tex/mathtools/MathtoolsConfiguration.js'
import 'mathjax-full/js/input/tex/mhchem/MhchemConfiguration.js'
import 'mathjax-full/js/input/tex/newcommand/NewcommandConfiguration.js'
import 'mathjax-full/js/input/tex/noerrors/NoErrorsConfiguration.js'
import 'mathjax-full/js/input/tex/noundefined/NoUndefinedConfiguration.js'
#import 'mathjax-full/js/input/tex/physics/PhysicsConfiguration.js'
import 'mathjax-full/js/input/tex/setoptions/SetOptionsConfiguration.js'
#import 'mathjax-full/js/input/tex/tagformat/TagFormatConfiguration.js'
import 'mathjax-full/js/input/tex/textcomp/TextcompConfiguration.js'
import 'mathjax-full/js/input/tex/textmacros/TextMacrosConfiguration.js'
import 'mathjax-full/js/input/tex/upgreek/UpgreekConfiguration.js'
#import 'mathjax-full/js/input/tex/unicode/UnicodeConfiguration.js'
import 'mathjax-full/js/input/tex/verb/VerbConfiguration.js'

## Create DOM adaptor and register it for HTML documents
adaptor = liteAdaptor()
RegisterHTMLHandler adaptor
#AssistiveMmlHandler handler

## Create input and output jax and a document using them on the content from the HTML file
tex = new TeX
  packages: [
    'base', 'ams', 'amscd', 'boldsymbol', 'braket', 'bussproofs', 'cancel'
    'centernot', 'color', 'colortbl', 'gensymb', 'mathtools', 'mhchem'
    'newcommand', 'noerrors', 'noundefined', 'setoptions'
    'textcomp', 'textmacros', 'upgreek', 'unicode', 'verb'
  ]
svg = new SVG
  fontCache: 'local'
html = mathjax.document '',
  InputJax: tex
  OutputJax: svg

globalThis.onmessage = (e) ->
  {formula, display, em, ex, containerWidth} = e.data
  return unless formula?
  node = html.convert formula,
    display: display
    em: em ? 16
    ex: ex ? 8
    containerWidth: containerWidth ? 80 * 16
  svg = adaptor.innerHTML node
  postMessage Object.assign e.data, {svg}
