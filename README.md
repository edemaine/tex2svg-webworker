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

1. `npm install tex2svg-webworker`
2. Copy `node_modules/tex2svg-webworker/dist/tex2svg.js` to your web directory.
3. In your JavaScript code, create Web Worker and prepare to receive messages:

   ```js
   worker = new Worker('webpath/tex2svg.js');
   worker.onmessage = function(e) {
     // e.data.svg is a string of the form "<svg...>...</svg>"
     // All inputs are also available; for example, e.data.formula
   };
   ```

4. Send rendering requests to the Web Worker as follows:

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
