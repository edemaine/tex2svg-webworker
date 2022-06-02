# tex2svg-webworker

This library enables a browser application to render
LaTeX math expressions into SVG with outlined symbols
(so no external fonts are required).
All rendering is done **in the background** using a
[Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers),
so it will not block the main JavaScript thread.

This library is a simple wrapper around [MathJax](https://www.mathjax.org/),
similar to their
[tex2svg Node demo](https://github.com/mathjax/MathJax-demos-node/blob/master/direct/tex2svg),
but built to be used as a Web Worker `.js` file.

## Usage

### Worker Creation, Option 1: CDN

* In your JavaScript code, create a Web Worker and prepare to receive messages:

  ```js
  worker = new Worker(window.URL.createObjectURL(new Blob([
    "importScripts('https://cdn.jsdelivr.net/npm/tex2svg-webworker/dist/tex2svg.js');"
    // or specify a specific version via .../npm/tex2svg-webworker@0.3.1/dist/...
  ], type: 'text/javascript'));
   worker.onmessage = function(e) {
     // e.data.svg is a string of the form "<svg...>...</svg>"
     // All inputs are also available; for example, e.data.formula
   };
  ```

### Worker Creation, Option 2: NPM

* `npm install tex2svg-webworker`
* Copy `node_modules/tex2svg-webworker/dist/tex2svg.js` to your web directory.
* In your JavaScript code, create a Web Worker and prepare to receive messages:

  ```js
  worker = new Worker('webpath/tex2svg.js');
  worker.onmessage = function(e) {
    // e.data.svg is a string of the form "<svg...>...</svg>"
    // All inputs are also available; for example, e.data.formula
  };
  ```

### Rendering LaTeX via Worker

* Send rendering requests to the Web Worker as follows:

  ```js
  worker.postMessage({
    formula: "e^{\\pi i} + 1 = 0",
    display: true,
  });
  ```

Note that the `formula` input does not include delimiters (e.g. `$`).
Additional options `em`, `ex`, and `containerWidth` are available;
see [tex2svg.coffee](tex2svg.coffee).

## Example

See [index.html](index.html) for a simple example of the rendering
request/response loop.

[Live demo of it in action](https://edemaine.github.io/tex2svg-webworker/)

[Cocreate](https://github.com/edemaine/cocreate/) is a larger application
(a shared whiteboard supporting LaTeX text) using this library (and indeed
it was the reason I wrote it).  The relevant code is in
[client/RenderObjects.coffee](https://github.com/edemaine/cocreate/blob/main/client/RenderObjects.coffee).

## Supported LaTeX Commands

In addition to
[MathJax's standard TeX/LaTeX commands](https://docs.mathjax.org/en/latest/input/tex/macros/index.html),
this library includes several of
[MathJax's TeX/LaTeX extensions](https://docs.mathjax.org/en/latest/input/tex/extensions/):

* [ams](https://docs.mathjax.org/en/latest/input/tex/extensions/ams.html): `\begin{align}`, etc.
* [amscmd](https://docs.mathjax.org/en/latest/input/tex/extensions/amscd.html): `\begin{CD}`
* [boldsymbol](https://docs.mathjax.org/en/latest/input/tex/extensions/boldsymbol.html): `\boldsymbol{bold++}`
* [braket](https://docs.mathjax.org/en/latest/input/tex/extensions/braket.html): `\braket{\phi | \psi}`, `\set{x \in X | x > 0}`, `\Set{\sum_{i=1}^n x^i | x \leq 1\}`
* [bussproofs](https://docs.mathjax.org/en/latest/input/tex/extensions/bussproofs.html): `\begin{prooftree}`
* [cancel](https://docs.mathjax.org/en/latest/input/tex/extensions/cancel.html): `\cancel{x}/\cancel{x}`
* [centernot](https://docs.mathjax.org/en/latest/input/tex/extensions/centernot.html): `\centernot\longrightarrow`
* [color](https://docs.mathjax.org/en/latest/input/tex/extensions/color.html): `\textcolor{purple}{hi}`
* [colortbl](https://docs.mathjax.org/en/latest/input/tex/extensions/colortbl.html): `\rowcolor`, `\columncolor`, `\cellcolor`
* [gensymb](https://docs.mathjax.org/en/latest/input/tex/extensions/gensymb.html): `\degree`, `\celsius`, `\micro`, `\ohm`, `\perthousand`
* [mathtools](https://docs.mathjax.org/en/latest/input/tex/extensions/mathtools.html): `\coloneq`, `\eqcolon`, ...
* [mhchem](https://docs.mathjax.org/en/latest/input/tex/extensions/mhchem.html): `\ce`
* [newcommand](https://docs.mathjax.org/en/latest/input/tex/extensions/newcommand.html): `\def`, `\newcommand`, `\newenvironment` (note that these span across multiple expressions)
* [noerrors](https://docs.mathjax.org/en/latest/input/tex/extensions/noerrors.html): render source in case of error
* [noundefined](https://docs.mathjax.org/en/latest/input/tex/extensions/noundefined.html): show undefined commands in red instead of throwing error
* [setoptions](https://docs.mathjax.org/en/latest/input/tex/extensions/setoptions.html): `\setOptions{tagSide=left}`, etc.
* [textcomp](https://docs.mathjax.org/en/latest/input/tex/extensions/textcomp.html): `\textasciitilde`, etc.
* [textmacros](https://docs.mathjax.org/en/latest/input/tex/extensions/textmacros.html): `\text{$x$ is \emph{good}}`
* [upgreek](https://docs.mathjax.org/en/latest/input/tex/extensions/upgreek.html): `\upalpha`, etc.
* [verb](https://docs.mathjax.org/en/latest/input/tex/extensions/verb.html): `\verb|$('div')|`

There is no need to
[`\require`](https://docs.mathjax.org/en/latest/input/tex/extensions/require.html)
any of these packages to use them.

On the other hand, the following packages are not currently included:

* [action](https://docs.mathjax.org/en/latest/input/tex/extensions/action.html) (MathML irrelevant for SVG output)
* [autoload](https://docs.mathjax.org/en/latest/input/tex/extensions/autoload.html) (irrelevant for Web Worker)
* [bbox](https://docs.mathjax.org/en/latest/input/tex/extensions/bbox.html) (use more standard `\colorbox{$...$}` instead)
* [cases](https://docs.mathjax.org/en/latest/input/tex/extensions/cases.html) (tags aren't great in SVG output)
* [configmacros](https://docs.mathjax.org/en/latest/input/tex/extensions/configmacros.html) (irrelevant for Web Worker)
* [empheq](https://docs.mathjax.org/en/latest/input/tex/extensions/empheq.html) (seems rarely used)
* [enclose](https://docs.mathjax.org/en/latest/input/tex/extensions/enclose.html) (MathML irrelevant for SVG output)
* [extpfeil](https://docs.mathjax.org/en/latest/input/tex/extensions/extpfeil.html) (not standard LaTeX)
* [html](https://docs.mathjax.org/en/latest/input/tex/extensions/html.html) (incompatible with SVG output)
* [require](https://docs.mathjax.org/en/latest/input/tex/extensions/require.html) (irrelevant for Web Worker)
* [physics](https://docs.mathjax.org/en/latest/input/tex/extensions/physics.html) (redefines e.g. `\div` to mean ∇ (`\grad`) instead of ÷)
* [tagformat](https://docs.mathjax.org/en/latest/input/tex/extensions/tagformat.html) (irrelevant for Web Worker)
* [unicode](https://docs.mathjax.org/en/latest/input/tex/extensions/unicode.html) (doesn't work well with SVG)
