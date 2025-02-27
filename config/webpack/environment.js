const { environment } = require('@rails/webpacker')

// Add Babel support for JSX and ES6+
const babelLoader = environment.loaders.get('babel')
babelLoader.use[0].options.presets.push('@babel/preset-react')

module.exports = environment
