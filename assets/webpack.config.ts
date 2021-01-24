import { Configuration } from "webpack"
import path from "path"
import glob from "glob"
import MiniCssExtractPlugin from "mini-css-extract-plugin"
import CopyWebpackPlugin from "copy-webpack-plugin"
import CssMinimizerPlugin from "css-minimizer-webpack-plugin"

const APP_ROOT = path.join(__dirname, "..")
const OUTPUT_PATH = path.resolve(APP_ROOT, 'priv/static/js')
const WEBWORKER_SOURCE_PATH = path.join(__dirname, "/js/serviceworker")
const BROWSER_SOURCE_PATH = path.join(__dirname, "/js/browser")
const SHARED_SOURCE_PATH = path.join(__dirname, "/js/shared")


module.exports = (_env: any, options: { [key: string]: string }): Configuration => {
    const devMode = options.mode !== 'production';

    return {
        optimization: {
            minimizer: [
                new CssMinimizerPlugin()
            ]
        },
        entry: {
            'startercode': glob.sync('./vendor/**/*.js').concat(['./js/browser/startercode.js']),
            'app': path.resolve(BROWSER_SOURCE_PATH, './app.ts'),
            'sw': path.resolve(WEBWORKER_SOURCE_PATH, './sw.ts')
        },
        watchOptions: devMode ? {
            aggregateTimeout: 200,
            poll: 1000,
        } : undefined,
        output: {
            filename: '[name].js',
            path: OUTPUT_PATH,
            publicPath: '/js/'
        },
        devtool: devMode ? 'source-map' : undefined,
        module: {
            rules: [
                {
                    test: /\.(j|t)sx?$/,
                    include: [BROWSER_SOURCE_PATH, SHARED_SOURCE_PATH],
                    exclude: /node_modules/,
                    use: [{
                        loader: 'babel-loader'
                    },
                    {
                        loader: "ts-loader",
                        options: {
                            instance: 'browser',
                            configFile: path.join(BROWSER_SOURCE_PATH, 'tsconfig.json'),
                        },
                    }]
                },
                {
                    test: /\.(j|t)s$/,
                    include: [WEBWORKER_SOURCE_PATH, SHARED_SOURCE_PATH],
                    exclude: /node_modules/,
                    use: [{
                        loader: 'babel-loader'
                    },
                    {
                        loader: "ts-loader",
                        options: {
                            instance: 'webworker',
                            configFile: path.join(WEBWORKER_SOURCE_PATH, 'tsconfig.json'),
                        },
                    }]
                },
                {
                    test: /\.[s]?css$/,
                    use: [
                        MiniCssExtractPlugin.loader,
                        'css-loader',
                        'postcss-loader',
                        'sass-loader',
                    ],
                }
            ]
        },
        resolve: {
            extensions: [".ts", ".js", ".tsx", ".jsx"]
        },
        plugins: [
            new MiniCssExtractPlugin({ filename: '../css/app.css' }),
            new CopyWebpackPlugin({ patterns: [{ from: 'static/', to: '../' }] })
        ]
    }
};