import coffee from 'rollup-plugin-coffee-script'
import resolve from '@rollup/plugin-node-resolve'
import commonjs from '@rollup/plugin-commonjs'
import {terser} from 'rollup-plugin-terser'

export default
  input: 'tex2svg.coffee'
  output:
    file: 'dist/tex2svg.js'
  plugins: [
    coffee()
    resolve
      extensions: ['.js', '.coffee']
    commonjs
      extensions: ['.js', '.coffee']
    terser()
  ]
