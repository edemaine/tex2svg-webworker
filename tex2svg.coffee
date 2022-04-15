## Based roughly on preload/tex2svg from
## https://github.com/mathjax/MathJax-demos-node

global.MathJax =
  tex: packages: [
    'base', 'autoload', 'require', 'ams', 'newcommand', 'textmacros'
    'noerrors', 'noundefined'
  ]
  svg: fontCache: 'local'
  startup:
    # Prevent MathJax from looking at document, sometimes available to Worker
    document: ''
    typeset: false

import 'mathjax-full/components/src/startup/lib/startup.js'
import 'mathjax-full/components/src/core/core.js'
import 'mathjax-full/components/src/adaptors/liteDOM/liteDOM.js'
import 'mathjax-full/components/src/input/tex-base/tex-base.js'
import 'mathjax-full/components/src/input/tex/extensions/all-packages/all-packages.js'
import 'mathjax-full/components/src/input/tex/extensions/textmacros/textmacros.js'
import 'mathjax-full/components/src/output/svg/svg.js'
import 'mathjax-full/components/src/output/svg/fonts/tex/tex.js'
import 'mathjax-full/components/src/startup/startup.js'

global.MathJax.loader.preLoad 'core', 'adaptors/liteDOM', 'input/tex-base',
  '[tex]/all-packages', '[tex]/textmacros',
  '[tex]/noerrors', '[tex]/noundefined',
  'output/svg', 'output/svg/fonts/tex'
global.MathJax.config.startup.ready()

global.onmessage = (e) ->
  {formula, display, em, ex, containerWidth} = e.data
  return unless formula?
  node = global.MathJax.tex2svg formula,
    display: display
    em: em ? 16
    ex: ex ? 8
    containerWidth: containerWidth ? 80 * 16
  svg = global.MathJax.startup.adaptor.outerHTML node
  .replace /^<mjx-container[^<>]*>/, ''
  .replace /<\/mjx-container>$/, ''
  postMessage Object.assign e.data, {svg}
