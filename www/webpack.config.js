const path = require('path');
const ROOT = path.resolve( __dirname, 'src' );
const DESTINATION = path.resolve( __dirname, 'www' );

const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    context: ROOT,

    output: {
        path: DESTINATION,
    },

    resolve: {
        extensions: ['.js']
    },

    plugins: [
        new HtmlWebpackPlugin({
            title: 'app',
            template: 'index.html',
            inject: true
        })
    ],

    entry: {
        app: './index.js'
    }
};