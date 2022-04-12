path = require 'path'

module.exports =
  mode: 'production'
  entry: './tex2svg.coffee'
  output:
    path: outputDir = path.resolve __dirname, 'dist'
    filename: 'tex2svg.js'
  module:
    rules: [
      test: /\.coffee$/
      exclude: /node_modules/
      loader: 'coffee-loader'
      options:
        bare: true
        transpile:
          presets: ['@babel/preset-env']
    ,
      test: /\.js$/
      exclude: /node_modules/
      loader: 'babel-loader'
      options:
        presets: ['@babel/preset-env']
    ]
  plugins: [
    new (require 'html-webpack-plugin')
      template: 'index.html'
  ]
  ## For testing:
  #mode: 'development'
  #optimization: usedExports: true
