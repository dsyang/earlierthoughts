module.exports = {
    "extends": "@istanbuljs/nyc-config-typescript",
    "all": true,
    "extension": [
        ".ts",
        ".js"
    ],
    "exclude": [
        "coverage/**",
        "*.config.js",
        "*.config.ts",
        "watch.js",
        "**/*.d.ts",
        "**/*.test.ts"
    ],
    "sourceMap": true,
    "reporter": [
        "html",
        "text",
        "text-summary"
    ],
    "instrument": true
}