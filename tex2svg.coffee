## Based roughly on preload/tex2svg from
## https://github.com/mathjax/MathJax-demos-node

global.MathJax =
  tex: packages: [
    'base', 'autoload', 'require', 'ams', 'newcommand', 'textmacros'
  ]
  svg: fontCache: 'local'
  startup: typeset: false

require 'mathjax-full/components/src/startup/lib/startup.js'
require 'mathjax-full/components/src/core/core.js'
require 'mathjax-full/components/src/adaptors/liteDOM/liteDOM.js'
require 'mathjax-full/components/src/input/tex-base/tex-base.js'
require 'mathjax-full/components/src/input/tex/extensions/all-packages/all-packages.js'
require 'mathjax-full/components/src/input/tex/extensions/textmacros/textmacros.js'
require 'mathjax-full/components/src/output/svg/svg.js'
require 'mathjax-full/components/src/output/svg/fonts/tex/tex.js'
require 'mathjax-full/components/src/startup/startup.js'

global.MathJax.loader.preLoad 'core', 'adaptors/liteDOM', 'input/tex-base',
  '[tex]/all-packages', '[tex]/textmacros', 'output/svg', 'output/svg/fonts/tex'
global.MathJax.config.startup.ready()

global.onmessage = (e) ->
  {formula, display, em, ex, containerWidth} = e.data
  node = global.MathJax.tex2svg formula,
    display: display
    em: em ? 16
    ex: ex ? 8
    containerWidth: containerWidth ? 80 * 16
  svg = global.MathJax.startup.adaptor.outerHTML node
  .replace /^<mjx-container[^<>]*>/, ''
  .replace /<\/mjx-container>$/, ''
  postMessage Object.assign e.data, {svg}
