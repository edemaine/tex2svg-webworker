# tex2svg-webworker

This library enables a browser application to render
LaTeX math expressions into SVG with outlined symbols
(so no external fonts are required).
All rendering is done **in the background** using a
[Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers),
so it will not block the main JavaScript thread.

This library is a simple wrapper around [MathJax](https://www.mathjax.org/),
similar to their
[tex2svg Node demo](https://github.com/mathjax/MathJax-demos-node/blob/master/preload/tex2svg),
but built to be used as a Web Worker `.js` file.

## Usage

### Worker Creation, Option 1: CDN

* In your JavaScript code, create a Web Worker and prepare to receive messages:

  ```js
  worker = new Worker(window.URL.createObjectURL(new Blob([
    "importScripts('https://cdn.jsdelivr.net/npm/tex2svg-webworker/dist/tex2svg.js');"
    // or specify a specific version via .../npm/tex2svg-webworker@0.1.1/dist/...
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
